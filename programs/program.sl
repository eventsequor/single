fun id x = x
fun fe p = (id p) * p
fun sqrt x y = x / y
fun main = fe (sqrt 8 2)
main