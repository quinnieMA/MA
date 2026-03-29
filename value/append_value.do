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
            replace `var' = "" if inlist(`var', "n.a.", "n.s.", "-","Unknown %","Unknown majority")
        }
    }

    // 保存处理后的精简文件
    compress  // 压缩数据以进一步节省空间
    save "`output_file'", replace
    di "文件已保存: `output_file' (已精简)"
end

// 主程序
clear
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\value\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\value"

// 处理1-4号文件
forvalues i = 1/2 {
    local input_file "`input_path'\acquisition_value_`i'_cleaned.csv"
    local output_file "`output_path'\acq_value_`i'.dta"
    
    di "正在处理文件 `i'/2: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/2 {
    local file "`output_path'\acq_value_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}

// 检查并处理重复项
drop if deal_value==.
bysort deal_num: keep if _n == 1

// 最终保存
drop as_reported_fee_income stake_init_pct stake_acq_pct stake_final_pct 
destring deal_equity_value-modelled_fee_income, replace
save "`output_path'\acq_value.dta", replace
di "处理完成！最终文件已保存: `output_path'\acq_value.dta"


local input_path "${ONEDRIVE_PATH}\MA1\01-deals\value\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\value"

use  "`output_path'\acq_value.dta", clear
// 定义需要取对数的交易价值变量
local value_vars ///
    deal_value ///
    deal_value_native_currency ///
    deal_equity_value ///
    deal_equity_value_native_currenc ///
    deal_enterprise_value ///
    deal_enterprise_value_native_cur ///
    deal_modelled_enterprise_value ///
    deal_modelled_enterprise_value_n ///
    deal_total_target_value ///
    deal_total_target_value_native_c ///
	modelled_fee_income

// 为所有交易价值变量计算自然对数
foreach var of local value_vars {
    capture confirm variable `var'
    if _rc == 0 {
        // 创建简洁的新变量名
        local newname = "ln_" + subinstr("`var'", "deal_", "", 1)
        
        // 检查是否已存在，如果存在则添加数字后缀
        capture confirm variable `newname'
        local j = 1
        while _rc == 0 {
            local tempname "`newname'_`j'"
            capture confirm variable `tempname'
            if _rc != 0 {
                local newname "`tempname'"
            }
            local j = `j' + 1
        }
        
        // 生成对数变量（只对正值取对数）
        gen `newname' = ln(`var') if `var' > 0 & `var' != .
        replace `newname' = . if `var' <= 0 | `var' == .
        
        label variable `newname' "ln(`var')"
        di "Created `newname' from `var'"
    }
    else {
        di "Variable `var' not found"
    }
}

// 显示所有新创建的对数变量
describe ln_*

// 保存处理后的数据
save "`output_path'\acq_value_with_ln.dta", replace

// 显示处理结果摘要
di "数据处理完成！"
di "原始变量数量: " _N
di "新创建的对数变量:"
ds ln_*
local ln_vars = r(varlist)
di "对数变量数量: " `: word count `ln_vars''
