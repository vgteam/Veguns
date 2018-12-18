class: CommandLineTool
cwlVersion: v1.0
doc: Retrieve rdf from uniprot the proteins for the proteomes

hints:
  SoftwareRequirement:
    packages:
      python3: {}


baseCommand: python3
inputs:
  filtered_ensemblgenomes_metadata:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
      import json
      import urllib.request
      with open('$(inputs.filtered_ensemblgenomes_metadata.path)', 'r') as f:
        genomes = json.load(f)
        with open('/dev/stdout', 'wb') as turtle:
          for genome in genomes:
            loc="https://www.uniprot.org/uniprot/?format=ttl&compressed=yes&query=proteome:(genome_assembly:"+genome['assembly_id']+")"
            #turtle.write(loc.encode('utf-8'))
            with urllib.request.urlopen(loc) as response:
              turtle.write(response.read())
outputs:
  concatenated_uniprot_turtle:
    type: File
    outputBinding:
      glob: uniprot.ttl.gz
stdout: uniprot.ttl.gz
