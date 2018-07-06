# ops-scripts
**bash/synchronize_file_variables.sh**
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

**ruby/hiera_deep_merge.rb**
------
**_Goal:_** Get all information about classes and parameters configuration for a specific node from hiera data based on facts.

Works with Puppet v5+ Hiera config file syntax (https://puppet.com/docs/puppet/5.0/hiera_config_yaml_5.html)

**_Usage:_** `./hiera_deep_merge.rb` (prompts for facts)

**_Output:_**
```bash
FACTS USED IN HIERARCHY:
-------------------------------------------------
NODETYPE: sandbox

YAML FILES TO BE MERGED:
-------------------------------------------------
./data/nodetype/sandbox.yaml
./data/global.yaml

DEEP-MERGING OUTPUT:
-------------------------------------------------
{"classes"=>
  ["sandbox::require_classes",
   "dummy",
   "chrony",
   "sudo",
   "ssh",
   "package"],
 "sandbox::require_classes::required_classes"=>
  ["sandbox::dummy1", "sandbox::dummy2"],
 "lookup_options"=>
  {"^(.*)::(.*)$"=>{"merge"=>{"strategy"=>"deep", "merge_hash_arrays"=>true}}},
 "chrony::local_config"=>"server 169.254.169.123 prefer iburst",
 "sudo::configs"=>
  {"wheel"=>{"priority"=>10, "content"=>"%wheel ALL=(ALL) NOPASSWD: ALL"}},
 "package::package"=>{"tcpdump"=>{}, "tree"=>{}, "jq"=>{}},
 "ssh::permit_root_login"=>"no"}
```