template init*(lvalue: var auto) =
  mixin init
  lvalue = init(type(lvalue))

template init*(lvalue: var auto, a1: auto)=
  mixin init
  lvalue = init(type(lvalue), a1)

template init*(lvalue: var auto, a1, a2: auto) =
  mixin init
  lvalue = init(type(lvalue), a1, a2)

template init*(lvalue: var auto, a1, a2, a3: auto) =
  mixin init
  lvalue = init(type(lvalue), a1, a2, a3)

when not declared(default):
  proc default*(T: type): T = discard

proc toArray*[T](N: static int, data: openarray[T]): array[N, T] =
  doAssert data.len == N
  copyMem(addr result[0], unsafeAddr data[0], N)

template anonConst*(val: untyped): untyped =
  const c = val
  c

func declval*(T: type): T {.compileTime.} =
  ## `declval` denotes an anonymous expression of a particular
  ## type. It can be used in situations where you want to determine
  ## the type of an overloaded call in `typeof` expressions.
  ##
  ## Example:
  ## ```
  ## type T = typeof foo(declval(string), declval(var int))
  ## ```
  ##
  ## Please note that `declval` has two advantages over `default`:
  ## 
  ## 1. It can return expressions with proper `var` or `lent` types.
  ## 
  ## 2. It will work for types that lack a valid default value due
  ##    to `not nil` or `requiresInit` requirements.
  ##
  doAssert false,
    "declvar should be used only in `typeof` expressions and concepts"
  default(ptr T)[]

when not compiles(len((1, 2))):
  import typetraits

  func len*(x: tuple): int =
    arity(type(x))

# Get an object's base type, as a cstring. Ref objects will have an ":ObjectType"
# suffix.
# From: https://gist.github.com/stefantalpalaru/82dc71bb547d6f9178b916e3ed5b527d
proc baseType*(obj: RootObj): cstring =
  when not defined(nimTypeNames):
    raiseAssert("you need to compile this with '-d:nimTypeNames'")
  else:
    {.emit: "result = `obj`->m_type->name;".}

proc baseType*(obj: ref RootObj): cstring =
  obj[].baseType

