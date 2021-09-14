# YAML

YAML is commonly used for configuration files and in applications where data is being stored or transmitted.

## Usage

### Strings

```yaml
key: this is a string

key: "this is also a string"

key: |
  this is a multi-line
  string with line breaks

key: >
  this a multi-line 
  string withouth line breaks
```

### Integers and floats

```yaml

integer: 595

float: 12.2

```

### Lists

```yaml

list1: [1, "two", 3]

list2:
  - 1
  - "two"
  - 3

```

### Objects

```yaml

my_obj:
  title: My Object
  description: This is a object
  childs:
	- test_obj:
		name: Test Object

```

### Comments

```yaml
# this is a comment
```

## Links
- [YAML Tutorial: Everything You Need to Get Started in Minutes](https://www.cloudbees.com/blog/yaml-tutorial-everything-you-need-get-started)