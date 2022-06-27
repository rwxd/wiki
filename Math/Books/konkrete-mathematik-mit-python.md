# Bearbeitung der Aufgaben von `Konkrete Mathematik mit Python`

## 15

```python
def potenz(a: int, b: int) -> int:
    p = 1
    while b > 0:
        p *= a
        b -= 1
    return p

assert potenz(2, 2) == 4
assert potenz(3, 3) == 27
assert potenz(3, 0) == 1
```

## 17 
