// 定义处理单个文件的程序
capture program drop process_file
program define process_file
    args input_file output_file
    
    // 导入CSV文件
    import delimited "`input_file'", bindquote(strict) clear
	keep ïunnamed__0 deal_num acq_name acq_country_code tar_name tar_country_code deal_type deal_status deal_value last_deal_status_date deal_headline tar_bvd_id_num tar_orbis_id_num acq_bvd_id_num acq_orbis_id_num ven_name ven_country_code ven_bvd_id_num ven_orbis_id_num regulatory_body_name regulatory_body_country type_of_deal_opportunity
    // +++ 新增部分：确保关键变量为字符串格式 +++
    local str_vars ïunnamed__0 deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num
    
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
local input_path "d:\OneDrive\MA1\01-deals\overview\cleaned_output\"
local output_path "d:\OneDrive\MA1\01-deals\overview\"

// 处理1-3号文件
forvalues i = 1/3 {
    local input_file "`input_path'\acquisition_overview_`i'_cleaned.csv"
    local output_file "`output_path'\acq_overview_`i'.dta"
    
    di "正在处理文件 `i'/3: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/3 {
    local file "`output_path'\acq_overview_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}
rename ïunnamed__0 ïunnamed_0
save "`output_path'\temp.dta", replace

        
		        // 定义需要处理的新变量列表
    gen original_valid_deal = !missing(deal_num)  // 标记原始有效的deal_num
    gen index =_n
	sort index
	local vars_to_process  deal_num 

     
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

drop if deal_num =="" 
bysort deal_num : egen regular_count=count(regulatory_body_name)

bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num acq_country_code tar_country_code ven_country_code: keep if _n == 1

save "`output_path'\temp.dta", replace

local input_path "d:\OneDrive\MA1\01-deals\overview\cleaned_output\"
local output_path "d:\OneDrive\MA1\01-deals\overview\"

	
use "`output_path'\temp.dta", clear
keep ïunnamed_0 deal_num tar_name tar_bvd_id_num tar_orbis_id_num tar_country_code
drop if tar_country_code ==""|tar_name==""
bysort deal_num: keep if _n == 1
save "`output_path'\acq_tar_country.dta", replace

use "`output_path'\temp.dta", clear
keep ïunnamed_0 deal_num acq_name acq_bvd_id_num acq_orbis_id_num acq_country_code
drop if acq_country_code ==""|acq_name==""
bysort deal_num : keep if _n == 1
save "`output_path'\acq_acq_country.dta", replace


use "`output_path'\temp.dta", clear
keep ïunnamed_0 deal_num ven_name ven_bvd_id_num ven_orbis_id_num ven_country_code  
drop if ven_country_code ==""|ven_name==""
bysort deal_num : keep if _n == 1
save "`output_path'\acq_ven_country.dta", replace

///////////////////////////////
   sort index ïunnamed_0 deal_num
	local vars_to_process  acq_name acq_country_code tar_name tar_country_code deal_type deal_status deal_value last_deal_status_date deal_headline tar_bvd_id_num tar_orbis_id_num acq_bvd_id_num acq_orbis_id_num ven_name ven_country_code ven_bvd_id_num ven_orbis_id_num regulatory_body_name regulatory_body_country type_of_deal_opportunity

     
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
            bysort index deal_num: replace `var' = `var'[_n-1] if missing(`var') & !missing(`var'[_n-1])
        }
        di "已完成变量: `var' 的前向填充"
    }


