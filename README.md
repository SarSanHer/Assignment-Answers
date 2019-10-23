# Assignment Answers

In this repository, the answers for the Bioinformatics Programming Challenges course assignments will be uploaded.

For the first assignmenr, run the following command:
>> ruby process_database.rb  gene_information.tsv  seed_stock_data.tsv  cross_data.tsv  new_stock_file.tsv

The first bonus can be checked by using a gene_information.tsv file with an incorrect ID format, which will abort the program and raise the error messagge: 
>> Error: invalid gene ID format in the gene ATfG36920 at position 0 of your file 
>> Make sure that ALL gene IDs from your gene file have ATxGxxxxx format

The second bonus can be checked by looking at the code, which includes the class methods object_name.load_from_file($seed_stock_data.tsv), object_name.write_database('new_stock_file.tsv') and object_name.get_seed_stock(id) to acces individual SeedStock objects based on their ID.
