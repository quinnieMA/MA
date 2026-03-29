// Define the base path to OneDrive
global ONEDRIVE_PATH "D:/OneDrive"  // Change this to match your OneDrive path

// 定义处理单个文件的程序
capture program drop process_file
program define process_file
    args input_file output_file
    
    // 导入CSV文件
    import delimited "`input_file'", bindquote(strict) clear
    
    // +++ 新增部分：确保关键变量为字符串格式 +++
    local str_vars ïunnamed_0 deal_num
    
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
    // +++ 新增部分结束 +++
    
    // 定义需要处理的新变量列表
    local vars_to_process ïunnamed_0 deal_num pre_rev_mul_ly pre_ebitda_mul_ly pre_ebit_mul_ly pre_pbt_mul_ly pre_pat_mul_ly pre_np_mul_ly pre_ta_mul_ly pre_na_mul_ly pre_cl_mul_ly pre_eq_mul_ly pre_cap_mul_ly post_rev_mul_fy post_ebitda_mul_fy post_ebit_mul_fy post_pbt_mul_fy post_pat_mul_fy post_np_mul_fy post_ta_mul_fy post_na_mul_fy post_cl_mul_fy post_eq_mul_fy post_cap_mul_fy


    // 第2步：识别变量类型并只对字符型变量替换"n.a."
    foreach var of local vars_to_process {
        // 获取变量类型
        capture confirm variable `var'
        if _rc {
            di "变量 `var' 不存在，跳过"
            continue
        }
        
        local vartype: type `var'
        
        // 判断是否为字符型变量
        if substr("`vartype'", 1, 3) == "str" {
            di "变量 `var' 是字符型，处理n.a.替换"
            replace `var' = "" if `var' == "n.a."|`var' == "n.s."|`var' == "-"
        }
        else {
            di "变量 `var' 是数值型(`vartype')，跳过n.a.处理"
        }
    }

    // 保存处理后的文件
    save "`output_file'", replace
    di "文件已保存: `output_file'"
end

// 主程序：处理所有文件并合并
clear

// 定义输入输出路径
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\multiple\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\multiple\"

// 处理1-8号文件
forvalues i = 1/2 {
    local input_file "`input_path'\acquisition_multiple_`i'_cleaned.csv"
    local output_file "`output_path'\acq_mul_`i'.dta"
    
    di "正在处理文件 `i'/2: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/2 {
    local file "`output_path'\acq_mul_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}


// 检查重复观测
duplicates tag deal_num, gen(dup)

// 查看重复情况
tab dup
list deal_num if dup > 0, abbreviate(20)
drop dup
// 处理重复项方案1：保留第一条记录
bysort deal_num: keep if _n == 1

// 保存最终合并文件
destring pre_rev_mul_ly-post_cap_mul_fy, replace
save "`output_path'\acq_mul.dta", replace
di "所有文件处理完成，最终合并文件已保存为: `output_path'\acq_mul.dta"
