# bash-scripts
**synchronize_file_variables.sh**
------
**_Goal:_** Synchronize variables between a template file and a destination file.

1. Whenever you add a new variable to the template file it will be added (with empty value) to your destination file.

2. Whenever you remove a variable from the template file a line that contains that variable in your destination file will be removed.

**_Usage:_** `./synchronize_file_variables.sh <template_file_path> <destination_file_path>`

**_template file_ structure**:
```python
var_1 = ""
var_2 = ""
var_3 = ""
```
