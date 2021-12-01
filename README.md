# ops-scripts
**bash/awssso_helper.sh**
------
**_Goal:_** Obtain temporary AWS credentials with AWS SSO and to use with AWS CLI or any AWS infrastructure orchestrator.

**_Usage:_**

Requires an AWS SSO profile to be configured. See source code for details.
```bash
$ source awssso_helper.sh
$ awssso
```

**_Output:_**
```
AWS SSO Profile: my-profile
[OK] Successully logged in.

Reading access token...
> SSO account ID: 012345678910
> SSO role name: AWSAdministratorAccess
> SSO region: eu-central-1
[OK] Access token retrieved successfully.

Getting SSO role credentials...
> User ID: AROARMXXXXXXXXXXXXXXX:username
[OK] AWS credentials retrieved successfully.

AWS region to work with [eu-central-1]:
[OK] AWS region set successfully.

$ env | grep AWS_
AWS_PROFILE=my-profile
AWS_ACCESS_KEY_ID=ASIARAIUWDBRSYFY...
AWS_SECRET_ACCESS_KEY=xrVlsUZ31IOK...
AWS_SESSION_TOKEN=IQoJb3JpZ2luX2Vj...
AWS_REGION=eu-central-1
```

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

**python/azure_ad_get_jwt.py**
------
**_Goal:_** Acquire JWT token based on username/password authentication against Azure AD.

**_Usage:_** `./azure_ad_get_jwt.py <username>`

**_Output:_**
```bash
USER: user1

ACCESS TOKEN:
 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c

JWT PAYLOAD:
 {
    "aud": "19fdd68c-4f2f-0000-be55-dd98124d4f74",
    "iss": "https://sts.windows.net/3c448d90-4ca1-9999-ab59-1a2aa67d7801/",
    "iat": 1568966476,
    "nbf": 1568966476,
    "exp": 1568967976,
    "acr": "1",
    "aio": "ASQA2/8MASDSDRPKP38sIc/ylhqKjW+d4SGJIpB6ASD26PTnOWpLpdtA=",
    "amr": [
        "pwd"
    ],
    "appid": "19fdd68c-4f2f-0000-be55-dd98124d4f74",
    "appidacr": "0",
    "ipaddr": "19.65.123.252",
    "name": "User 1",
    "oid": "f812acea-e123-4b32-b520-ca6cf6f13429",
    "scp": "Directory.Read.All User.Read",
    "sub": "PkK9GLBDstCKW7_1OBM6asDasdasdfaMazlO29EufmcZUM",
    "tid": "3c448d90-4ca1-9999-ab59-1a2aa67d7801",
    "unique_name": "user1@company.onmicrosoft.com",
    "upn": "user1@company.onmicrosoft.com",
    "uti": "AucHR-DhASDAdk6cIhxc0tAA",
    "ver": "1.0"
}

ENJOY!
```
