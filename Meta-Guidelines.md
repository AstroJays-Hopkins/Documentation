# Guidelines for Specification Documents 
Version: 0.0.1  
Date: 29 September 2019  
Status: Draft  
Type: Meta-Specification  
ID: 0M

## Description
All specifications must have the following components:

1. Title
2. Header
3. Description or Overview section
4. Requirements section

and may also contain a "Components" and "Implementation" section as deemed
necessary. Specifications must be written in markdown or asciidoc syntax, to
ensure that the plaintext is equally readable. 

## Title and Header
The title should be a concise description of what the specification covers. All
titles for specifications must be unique to prevent confusion.

The header serves as the "metadata" for the specification and should only
contain the following fields:

1. Version: Following [semver](https://semver.org/) specifications
2. Date: Indicating the date that the specification was last updated
3. Status: Indicating where the specification lies alsong the specification
   lifecycle
4. Type: Describing what type of document it is. Must be one of the following
   values:
   1. "Specification": Engineering specifications for systems, formats, and
      components
   2. "Meta-Specification": Specifications about specifications are
      specification lifecycle and usage.
5. ID: A unique number assigned to each spec when it reaches draft
   status that serves as an official alias.

When creating the header, each line should ahve two space characters (`  `) to
force a new line betweem each item.

### Example title and header
```markdown
# B System Specifications
Version: 0.1.1  
Date: 20 September 2019  
Status: Draft  
Type: Meta-Specification  
```
## Overview/Desciption
This section shall contain a short description of the thing covered byt hte
specification, as well as a brief overview specification conditions.

## Requirements
This section shall list each requirement of an implementation that is *in spec*
Each item listed here must be verified before the system is declared complete.
Definitions written here shall follow meta-spec 1M "Keywords for use in
specifications"
