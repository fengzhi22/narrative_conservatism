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
      
		4_statistics_10-Q: create dataset crsp_comp_edgar_10-Q.csv
		
		1) merge id_data.csv and text_data.csv with Compustat and CRSP data
		
		2) variable creation and data screening
		
		3) generate summary statistics of firm and text characteristics
		
		4_statistics_ibes_seg_10-Q: create final dataset crsp_comp_edgar_ibes_seg_10-Q.csv for regression analysis, and crsp_comp_edgar_ibes_seg_DA_10-Q.csv for Huang et al. 2014 main results replication
		
		1) merge crsp_comp_edgar_10-Q.csv with IBES and SEGMENT data
		
		2) variable creation and data screening
		
		3) generate summary statistics of firm and text characteristics
		
		4_statistics_8-K: create final dataset crsp_comp_edgar_8-K.csv for regression analysis
		
		1) merge quarterly COMP with daily CRSP: COMP_CRSP
		
		2) prepare EDGAR 8-K data for merge: agregate data from individual 8-K level to firm-day 8-K filings level
		
		3) merge EDGAR with COMP_CRSP
		
		4) generate summary statistics of firm and text characteristics
		
		5_regression.do: generate regression results and make tables in STATA
    
		Note: The first three procedures (1_scrape, 2_clean and 3_count) involves information retrival for millions filings, so they take substantial amount of time. Therefore, they are split into various time periods to allow for several kernels working at the same time, in order to reduce processing time.
  
  2. filings:
	
		Raw data: COMPUSTAT, COMPUSTAT_SEGMENT, CRSP (daily and monthly) and IBES 
      
		Processed data: web_url_index.txt, id_data.csv, text_data.csv and crsp_comp_edgar.csv, crsp_comp_edgar_ibes_seg.csv
    
		Note: 
		
		1) Due to hard drive storage limitation, the clean EDGAR filings in accessin_number.txt format are not stored in this github folder, but can be obtained by running 2_clean.ipynb script, and are available upon request.
		
		2) Due to hard drive storage limitation, raw file crsp_daily.csv (5.10GB) and processed file comp_crsp_8-K.csv (8.28GB) are not stored in this github folder.
    
  3. output: 
  
  		Figures: 1) project outline 2) data selection process
		
		Tables: 1) Summary statistics for both 10-Q and 8-K 2) 10-Q main results 3) 10-Q ABTONE results 4) 8-K results 
		
  4. latex: create final output NC.tex and NC.pdf
  
  5. LM: Loughran and McDonald dictionary, taken from the following link:
  
  		https://sraf.nd.edu/textual-analysis/resources/#LM%20Sentiment%20Word%20Lists
