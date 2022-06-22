# Show window class names

Run the following command, after that click on a window to see it class name

```bash
xprop | grep -i "class"
```

## Example

```bash
❯ xprop | grep -i "class"
WM_CLASS(STRING) = "todoist", "Todoist"
```
