

export const fromImpl = (name) => () => import(name).then(m => { return m })

export const fromDefaultImpl = (name) => () => import(name).then(m => { return m.default })

export const effectful3 = (f) => {
    return (a) => {
        return (b) => {
            return (c) => {
                return () => {
                    return f(a, b, c)
                }
            }
        }
    }
}

export const scoped3 = (m) => (f) => {
    return (a) => {
        return (b) => {
            return (c) => {
                const g = f.bind(m)
                return g(a, b, c)
            }
        }
    }
}

export const effectful2 = (f) => {
    return (a) => {
        return (b) => {
            return () => {
                return f(a, b)
            }
        }
    }
}

export const effectful1 = (f) => {
    return (a) => {
        return () => {
            return f(a)
        }
    }
}

export const variadicImpl = (f) => (args) => {
    return f(...args)
}

export const varargs1 = (a) => [a]
export const varargs2 = (a) => (b) => [a, b]
