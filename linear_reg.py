import matplotlib.pyplot as plt


def linear_regression(x, y):
    n = len(x)

    # means of x and y
    m_x = sum(x) / n
    m_y = sum(y) / n

    # slope (m) intercept (b)
    n = sum((xi - m_x) * (yi - m_y) for xi, yi in zip(x, y))
    d = sum((xi - m_x)**2 for xi in x)

    m = n / d 
    b = m_y - m * m_x

    return m, b

# quick and dirty, but works
P = [1,3,6,10,15]

omegas = [2282.65,2282.83,2283.36,2283.94,2284.68]

gammas = [0.20038,0.59804,1.19851,2.00033,3.00943]

g = linear_regression(P, gammas)
o = linear_regression(P, omegas)

print(f'linear regression for gamma (slope/intercept): {linear_regression(P, gammas)}')

print(f'linear regression for omega (slope/intercept): {linear_regression(P, omegas)}')

plt.plot([P[0], P[-1]], [o[0]*P[0]+o[1], o[0]*P[-1]+o[1]], 'r', label="linear regression", alpha=0.6)
plt.plot(P, omegas, 'bo', label="data points", alpha=0.4)
plt.title("Linear regression for omega")
plt.xlabel("Pression")
plt.ylabel("Omega")
plt.legend()
plt.show()



plt.plot([P[0], P[-1]], [g[0]*P[0]+g[1], g[0]*P[-1]+g[1]], 'r', label="linear regression", alpha=0.6)
plt.plot(P, gammas, 'bo', label="data points", alpha=0.4)
plt.title("Linear regression for gamma")
plt.xlabel("Pression")
plt.ylabel("Gamma")
plt.legend()
plt.show()



