######################## 2D ##############################################
function ellipsis(paxis,center=ones(2))
    f          = (s) -> paxis.*[cospi(s[1]),sinpi(s[1])]
    domain     = HyperRectangle(-1.0,2.0)
    surf       = ParametricEntity(f,domain)
    return surf
end
circle(rad=1,center=ones(2)) = ellipsis(rad*ones(2),center)

function kite(rad=1,center=ones(2))
    f(s)   = rad.*[cospi(s[1]) + 0.65*cospi(2*s[1]) - 0.65,
                1.5*sinpi(s[1])]
    domain = HyperRectangle(-1.0,2.0)
    surf   = ParametricEntity(f,domain)
    return surf
end

######################## 3D ##############################################
function cube(paxis=ones(3),center=zeros(3))
    nparts = 6
    domain = HyperRectangle(-1.,-1.,2.,2.)
    parts = ParametricEntity[]
    for id=1:nparts
        param(x) = _cube_parametrization(x[1],x[2],id,paxis,center)
        patch    = ParametricEntity(param,domain)
        push!(parts,patch)
    end
    return ParametricBody(parts)
end

function ellipsoid(paxis=ones(3),center=zeros(3))
    nparts = 6
    domain = HyperRectangle(-1.,-1.,2.,2.)
    parts = ParametricEntity[]
    for id=1:nparts
        param(x) = _ellipsoid_parametrization(x[1],x[2],id,paxis,center)
        patch = ParametricEntity(param,domain)
        push!(parts,patch)
    end
    return ParametricBody(parts)
end
sphere(rad=1,center=zeros(3)) = ellipsoid(rad*ones(3),center)

function bean(paxis=ones(3),center=zeros(3))
    nparts = 6
    domain = HyperRectangle(-1.,-1.,2.,2.)
    parts  = ParametricEntity[]
    for id=1:nparts
        param(x) = _bean_parametrization(x[1],x[2],id,paxis,center)
        patch    = ParametricEntity(param,domain)
        push!(parts,patch)
    end
    return ParametricBody(parts)
end

## cube
function _cube_parametrization(u,v,id,paxis,center)
    if id==1
        x = [1.,u,v]
    elseif id==2
        x = [-u,1.,v];
    elseif id==3
        x = [u,v,1.];
    elseif id==4
        x =[-1.,-u,v];
    elseif id==5
        x = [u,-1.,v];
    elseif id==6
        x = [-u,v,-1.];
    end
    return center .+ paxis.*x
end

## sphere
function _sphere_parametrization(u,v,id,rad=1,center=zeros(3))
    x = _cube_parametrization(u,v,id,ones(3),zeros(3))
    return center .+ rad.*x./sqrt(u^2+v^2+1)
end

function _ellipsoid_parametrization(u,v,id,paxis=ones(3),center=zeros(3))
    x = __sphere_parametrization(u,v,id)
    return x .* paxis .+ center
end

function _bean_parametrization(u,v,id,paxis=one(3),center=zeros(3))
    x = __sphere_parametrization(u,v,id)
    a = 0.8; b = 0.8; alpha1 = 0.3; alpha2 = 0.4; alpha3=0.1
    x[1] = a*sqrt(1.0-alpha3*cospi(x[3])).*x[1]
    x[2] =-alpha1*cospi(x[3])+b*sqrt(1.0-alpha2*cospi(x[3])).*x[2];
    x[3] = x[3];
    return x .* paxis .+ center
end
