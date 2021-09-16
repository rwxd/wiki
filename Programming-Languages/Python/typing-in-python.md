# Typing in Python

In Python typing can be optionally used. To check typing the standard tool is [MyPy](MyPy.md).

## Usage

### Function annotations

```python
def func(arg: arg_type, optarg: arg_type = default) -> return_type: 
...
```

For arguments the syntax is `argument: annotation`, while the return type is annotated using `-> annotation`. Note that the annotation must be a valid Python expression.

### Variable annotations

Sometimes the type checker needs help in figuring out the types of variables as well. The syntax is similar:

```python
pi: float = 3.142

def circumference(radius: float) -> float:
    return 2 * pi * radius`
```

## Links
- [Real python article on type checking](https://realpython.com/python-type-checking/#type-systems)