# narrative_conservatism
This repo contains the following contents:
  1. code:
  
		1_scrape: create two output files which consist of header info for each Edgar filing 
		
		1) web_url_index.txt: a list of urls of HTML-format Edgar filings, excluding exhibits.
      
		2) id_data.csv: a data set of filing headers, including accnum, file_type, cik, name, sic, fd, rp, fye, item8k, bazip and state
		
		2_clean: download all clean Edgar filings in accession_number.txt format. Cleaning steps are:
		
		1) delete nondisplay section
			
      2) delete tables that contains more than 4 numbers
			
      3) delete all HTML tags
      
		3_count: apply LM dictionary to count number of words in clean texts and save counts to text_data.csv
         
		1) text_data.csv: a data set of word counts with various dimensions: pos, neg, litigious, uncertainty, modal words etc.      
      
		4_statistics: create final dataset id_crsp_comp_text_obj-type.csv for regression analysis
		
		1) merging id_data.csv and text_data.csv with Compustat and CRSP data
		
		2) variable creation and data screening
		
		3) generate summary statistics (TABLE 1) of firm and text characteristics
		
		4_statistics_ibes: create final dataset crsp_comp_edgar_ibes_seg.csv for regression analysis
		
		1) merging id_crsp_comp_text.csv with IBES and SEGMENT data
		
		2) variable creation and data screening
		
		3) generate summary statistics (TABLE 3) of firm and text characteristics
		
		5_regression.do: generate regression results (TABLE 2 and TABLE 4) in STATA
    
		Note: The first three procedures (1_scrape, 2_clean and 3_count) involves information retrival for millions filings, so they take substantial amount of time. Therefore, they are split into various time periods to allow for several kernels working at the same time, in order to reduce processing time.
  
  2. filings:
	
		i) raw data: COMPUSTAT, COMPUSTAT_SEGMENT, CRSP and IBES 
      
		ii) processed data: web_url_index.txt, id_data.csv, text_data.csv and id_crsp_comp_text.csv, crsp_comp_edgar_ibes_seg.csv
    
		Note: Due to hard drive storage limitation, the clean Edgar filings in accessin_number.txt format are not stored in this folder, but can be obtained by running 2_clean.ipynb script, and are available upon request.
    
  3. output: figure and tables
  
  4. LM: Loughran and McDonald dictionary, taken from the following link:
  
  		https://sraf.nd.edu/textual-analysis/resources/#LM%20Sentiment%20Word%20Lists
