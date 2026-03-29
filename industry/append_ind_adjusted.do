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
    
    // +++ 第一步：先删除描述性变量以节省内存 +++
    local descr_vars ///
        tar_major_sector tar_trade_descr_orig tar_primary_busi_descr tar_primary_bvd_code tar_primary_bvd_descr tar_bvd_codes tar_bvd_descr tar_primary_sic_descr tar_sic_descr tar_primary_uk_sic_code tar_primary_uk_sic_descr tar_uk_sic_codes tar_uk_sic_descr tar_primary_nace_code tar_primary_nace_descr tar_nace_codes tar_nace_descr tar_primary_naics_code tar_primary_naics_descr tar_naics_codes tar_naics_descr acq_major_sector acq_trade_descr_orig acq_primary_busi_descr acq_primary_bvd_code acq_primary_bvd_descr acq_bvd_codes acq_bvd_descr acq_primary_sic_descr acq_sic_descr acq_primary_uk_sic_code acq_primary_uk_sic_descr acq_uk_sic_codes acq_uk_sic_descr acq_primary_nace_code acq_primary_nace_descr acq_nace_codes acq_nace_descr acq_primary_naics_code acq_primary_naics_descr acq_naics_codes acq_naics_descr ven_major_sector  ven_trade_descr_orig ven_primary_busi_descr  ven_primary_bvd_code ven_primary_bvd_descr ven_bvd_codes ven_bvd_descr ven_primary_sic_descr  ven_sic_descr ven_primary_uk_sic_code ven_primary_uk_sic_descr ven_uk_sic_codes ven_uk_sic_descr ven_primary_nace_code ven_primary_nace_descr ven_nace_codes ven_nace_descr ven_primary_naics_code ven_primary_naics_descr ven_naics_codes ven_naics_descr
        
    foreach pattern in `descr_vars' {
        capture unab todrop : `pattern'
        if !_rc {
            di "删除变量模式: `pattern'"
            drop `todrop'
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
local input_path "D:\OneDrive\MA1\01-deals\industry\cleaned_output1\"
local output_path "D:\OneDrive\MA1\01-deals\industry\"

// 处理1-5号文件
forvalues i = 1/5 {
    local input_file "`input_path'\acquisition_industry_`i'_cleaned.csv"
    local output_file "`output_path'\acq_ind_`i'.dta"
    
    di "正在处理文件 `i'/5: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/5 {
    local file "`output_path'\acq_ind_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}


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
	
local input_path "D:\OneDrive\MA1\01-deals\industry\cleaned_output1\"
local output_path "D:\OneDrive\MA1\01-deals\industry\"
	

rename ïunnamed__0 ïunnamed_0

bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num: keep if _n == 1
save "`output_path'\temp.dta", replace

local input_path "D:\OneDrive\MA1\01-deals\industry\cleaned_output1\"
local output_path "D:\OneDrive\MA1\01-deals\industry\"
use "`output_path'\temp.dta", clear
keep deal_num ïunnamed_0 tar_overview tar_trade_descr_en tar_busi_descr tar_primary_sic_code tar_sic_codes tar_name tar_bvd_id_num tar_orbis_id_num
drop if tar_primary_sic_code==.

/*. bysort deal_num : keep if _n == 1
(3,385 observations deleted)

. save "D:\OneDrive\MA\acquisition\industry\acq_tar_ind_to_merge.dta", replace
*/

*drop if tar_bvd_id_num==""| tar_orbis_id_num==./*去除掉信息不够多的否则tar太多每个的ind可能不一样，去重以后会随机保留一条信息而这条信息的ind可能不可控导致后续merge的结果有一定随机*/
bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num: keep if _n == 1
save "`output_path'\acq_tar_ind.dta", replace

local input_path "D:\OneDrive\MA1\01-deals\industry\cleaned_output1\"
local output_path "D:\OneDrive\MA1\01-deals\industry\"
use "`output_path'\temp.dta", clear
keep ïunnamed_0 deal_num acq_overview acq_trade_descr_en acq_busi_descr acq_primary_sic_code acq_sic_codes  acq_name acq_bvd_id_num acq_orbis_id_num
drop if acq_primary_sic_code==.
drop if acq_bvd_id_num==""| acq_orbis_id_num==./*去除掉信息不够多的否则tar太多每个的ind可能不一样，去重以后会随机保留一条信息而这条信息的ind可能不可控导致后续merge的结果有一定随机*/
bysort  deal_num acq_name acq_bvd_id_num acq_orbis_id_num: keep if _n == 1
save "`output_path'\acq_acq_ind.dta", replace

local input_path "D:\OneDrive\MA1\01-deals\industry\cleaned_output1\"
local output_path "D:\OneDrive\MA1\01-deals\industry\"

use "`output_path'\temp.dta", clear
keep ïunnamed_0 deal_num  ven_overview ven_trade_descr_en ven_busi_descr  ven_primary_sic_code  ven_sic_codes ven_name ven_bvd_id_num ven_orbis_id_num
drop if ven_primary_sic_code==.
drop if ven_bvd_id_num==""| ven_orbis_id_num==./*去除掉信息不够多的否则tar太多每个的ind可能不一样，去重以后会随机保留一条信息而这条信息的ind可能不可控导致后续merge的结果有一定随机*/

bysort  deal_num  ven_name ven_bvd_id_num ven_orbis_id_num: keep if _n ==1 
save "`output_path'\acq_ven_ind.dta", replace


