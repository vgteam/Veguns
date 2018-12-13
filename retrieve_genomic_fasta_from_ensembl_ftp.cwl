class: CommandLineTool
cwlVersion: v1.0
doc: Retrieve chromosomal fastas  id’s for the assemblys that are present in UniProtKB

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
            loc="/pub/current/bacteria/fasta/"+collection+"/"+genome['species']+"/dna/"
            genomeFasta=genome['species'].capitalize()+'.'+genome['assembly_name']+'.dna.chromosome.Chromosome.fa.gz'
            with urllib.request.urlopen('ftp://ftp.ensemblgenomes.org'+loc+genomeFasta) as response:
              fasta.write(response.read())

outputs:
  concatenated_ensembl_fasta:
    type: File
    outputBinding:
      glob: ensembl.fasta.gz
stdout: ensembl.fasta.gz
