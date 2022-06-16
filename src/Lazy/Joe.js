
export const fromImpl = (name) => () => import(name).then(m => { return m })

export const fromDefaultImpl = (name) => () => import(name).then(m => { return m.default })


export const scoped1 = (m) => (f) => (a) => {
    const g = f.bind(m)
    return g(a)
}

export const scoped2 = (m) => (f) => (a) => (b) => {
    const g = f.bind(m)
    return g(a, b)
}

export const scoped3 = (m) => (f) => (a) => (b) => (c) => {
    const g = f.bind(m)
    return g(a, b, c)
}

export const scoped4 = (m) => (f) => (a) => (b) => (c) => (d) => {
    const g = f.bind(m)
    return g(a, b, c, d)
}

export const scoped5 = (m) => (f) => (a) => (b) => (c) => (d) => (e) => {
    const g = f.bind(m)
    return g(a, b, c, d, e)
}

export const effectful1 = (f) => (a) => () => f(a)

export const effectful2 = (f) => (a) => (b) => () => f(a, b)

export const effectful3 = (f) => (a) => (b) => (c) => () => f(a, b, c)

export const effectful4 = (f) => (a) => (b) => (c) => (d) => () => f(a, b, c, d)

export const effectful5 = (f) => (a) => (b) => (c) => (d) => (e) => () => f(a, b, c, d, e)

export const variadicImpl = (f) => (args) => {
    return f(...args)
}

export const varargs1 = (a) => [a]
export const varargs2 = (a) => (b) => [a, b]
export const varargs3 = (a) => (b) => (c) => [a, b, c]
export const varargs4 = (a) => (b) => (c) => (d) => [a, b, c, d]
export const varargs5 = (a) => (b) => (c) => (d) => (e) => [a, b, c, d, e]

export const new0 = (obj) => {
    return new obj()
}

export const new1 = (obj) => (arg1) => {
    return new obj(arg1)
}

export const new2 = (obj) => (arg1) => (arg2) => {
    return new obj(arg1, arg2)
}

export const new3 = (obj) => (arg1) => (arg2) => (arg3) => {
    return new obj(arg1, arg2, arg3)
}

export const new4 = (obj) => (arg1) => (arg2) => (arg3) => (arg4) => {
    return new obj(arg1, arg2, arg3, arg4)
}

export const new5 = (obj) => (arg1) => (arg2) => (arg3) => (arg4) => (arg5) => {
    return new obj(arg1, arg2, arg3, arg4, arg5)
}
