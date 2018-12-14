class: CommandLineTool
cwlVersion: v1.0
doc: Retrieve ttl from ensemblgenomes the assemblys that are present in UniProtKB

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
        with open('/dev/stdout', 'wb') as fasta:
          for genome in genomes:
            collection=genome['dbname'].lower().split('_core')[0]
            loc="/pub/current/bacteria/rdf/"+collection+"/"+genome['species']+'/'
            genomeTtl=genome['species']+'.ttl.gz'
            with urllib.request.urlopen('ftp://ftp.ensemblgenomes.org'+loc+genomeTtl) as response:
              fasta.write(response.read())
            genomeXref=genome['species']+'.ttl.gz'
            with urllib.request.urlopen('ftp://ftp.ensemblgenomes.org'+loc+genomeXref) as response:
              fasta.write(response.read())

outputs:
  concatenated_ensembl_turtle:
    type: File
    outputBinding:
      glob: ensembl.ttl.gz
stdout: ensembl.ttl.gz
