// Define the base path to OneDrive
global ONEDRIVE_PATH "D:/OneDrive"  // Change this to match your OneDrive path

// 定义处理单个文件的程序
capture program drop process_file
program define process_file
    args input_file output_file
    
    // 导入CSV文件
    import delimited "`input_file'", bindquote(strict) clear
    
    // +++ 新增部分：确保关键变量为字符串格式 +++
    local str_vars ïunnamed__0 deal_num
    
    foreach var of local str_vars {
        capture confirm variable `var'
        if _rc == 0 {  // 只有当变量存在时才处理
            local vartype: type `var'
            if substr("`vartype'", 1, 3) != "str" {
                di "将变量 `var' 从 `vartype' 转换为字符串格式"
                tostring `var', replace force
                replace `var' = "" if `var' == "."
            }
        }
    }
            
    // 第3步：替换字符型变量中的特殊缺失值
    foreach var of varlist _all {
        capture confirm variable `var'
        if _rc continue
        
        local vartype: type `var'
        if substr("`vartype'", 1, 3) == "str" {
            replace `var' = "" if inlist(`var', "n.a.", "n.s.", "-", "NA")
        }
    }


    // 保存处理后的精简文件
    compress  // 压缩数据以进一步节省空间
    save "`output_file'", replace
    di "文件已保存: `output_file' (已精简)"
end

// 主程序
clear
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\legal\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\legal"

// 处理1-4号文件
forvalues i = 1/2 {
    local input_file "`input_path'\acquisition_legal_`i'_cleaned.csv"
    local output_file "`output_path'\acq_legal_`i'.dta"
    
    di "正在处理文件 `i'/2: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/2 {
    local file "`output_path'\acq_legal_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}

rename ïdeal_num deal_num
gen index=_n
local vars_to_process  deal_num  
sort index

    // 第2步：执行前向填充（用前一个非缺失值填充当前缺失值）
    foreach var of local vars_to_process {
        capture confirm variable `var'
        if _rc continue
        
        local vartype: type `var'
        
        // 根据不同类型处理缺失值
        if substr("`vartype'", 1, 3) == "str" {
            replace `var' = `var'[_n-1] if `var' == "" & `var'[_n-1] != ""
        }
        else {
            replace `var' = `var'[_n-1] if missing(`var') & !missing(`var'[_n-1])
        }
        di "已完成变量: `var' 的前向填充"
    }


// 检查并处理重复项
*rename ïunnamed__0 ïunnamed_0
*duplicates tag ïunnamed_0 deal_num, gen(dup)
*bysort ïunnamed_0 deal_num: keep if _n == 1
duplicates tag deal_num, gen(dup)
bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num: keep if _n == 1
drop dup
tostring deal_num, replace
 bysort deal_num tar_name  acq_name  ven_name deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num:keep if _n==1
// 最终保存
save "`output_path'\acq_legal.dta", replace
di "处理完成！最终文件已保存: `output_path'\acq_legal.dta"


use "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_legal.dta",clear
keep deal_num   tar_status tar_ent_type tar_legal_form tar_incorp_d tar_bvd_indep tar_acct_types tar_filing_type tar_last_acct_d tar_acct_pub tar_name tar_bvd_id_num tar_orbis_id_num tar_incorp_d_year tar_last_acct_d_year
drop if tar_incorp_d_year==.
bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num:keep if _n==1
save "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_tar_legal.dta",replace

use "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_legal.dta",clear
keep deal_num  acq_status acq_ent_type acq_legal_form acq_incorp_d acq_bvd_indep acq_acct_types acq_filing_type acq_last_acct_d acq_acct_pub acq_name acq_bvd_id_num acq_orbis_id_num acq_incorp_d_year acq_last_acct_d_year
drop if acq_incorp_d_year==.
bysort deal_num acq_name acq_bvd_id_num acq_orbis_id_num:keep if _n==1
save "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_acq_legal.dta",replace	

use "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_legal.dta",clear
keep deal_num ven_status ven_ent_type ven_legal_form ven_incorp_d ven_bvd_indep ven_acct_types ven_filing_type ven_last_acct_d ven_acct_pub ven_name ven_bvd_id_num ven_orbis_id_num ven_incorp_d_year ven_last_acct_d_year
drop if ven_incorp_d_year==.
bysort deal_num ven_name ven_bvd_id_num ven_orbis_id_num:keep if _n==1
save "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_ven_legal.dta",replace	
///////////////////////
use "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_legal.dta",clear
keep deal_num  tar_name tar_bvd_id_num tar_orbis_id_num 
drop if tar_name==""
bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num:keep if _n==1
bysort deal_num:egen tar_count=count( tar_name)
save "${ONEDRIVE_PATH}\MA1\01-deals\legal\tar_count.dta",replace

use "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_legal.dta",clear
keep deal_num  acq_name acq_bvd_id_num acq_orbis_id_num 
drop if acq_name==""
bysort deal_num acq_name acq_bvd_id_num acq_orbis_id_num:keep if _n==1
bysort deal_num:egen acq_count=count( acq_name)
save "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_count.dta",replace	

use "${ONEDRIVE_PATH}\MA1\01-deals\legal\acq_legal.dta",clear
keep deal_num ven_name ven_bvd_id_num ven_orbis_id_num 
drop if ven_name==""
bysort deal_num ven_name ven_bvd_id_num ven_orbis_id_num:keep if _n==1
save "${ONEDRIVE_PATH}\MA1\01-deals\legal\ven_count.dta",replace	

