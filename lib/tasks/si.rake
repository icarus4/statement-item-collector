namespace :si do
  desc "Fill xbrl names to si_xbrl_mappings"
  task fill: :environment do
    StandardItem.all.each do |si|
      case si.name
      when 'Revenue'
      when 'Other Revenue, Total'
      when 'Total Revenue'
        si.xbrl_names.find_or_create_by(xbrl_name: 'Revenues')
        si.xbrl_names.find_or_create_by(xbrl_name: 'RevenuesNet')
        si.xbrl_names.find_or_create_by(xbrl_name: 'RevenuesOperatingAndNonoperating')
        si.xbrl_names.find_or_create_by(xbrl_name: 'RevenueFromRelatedParties')
        si.xbrl_names.find_or_create_by(xbrl_name: 'SalesRevenueGoodsNet')
        si.xbrl_names.find_or_create_by(xbrl_name: 'SalesRevenueServicesNet')
        si.xbrl_names.find_or_create_by(xbrl_name: 'SalesRevenueNet')
        si.xbrl_names.find_or_create_by(xbrl_name: 'OilAndGasRevenue')
        si.xbrl_names.find_or_create_by(xbrl_name: 'OilAndGasSalesRevenue')
        si.xbrl_names.find_or_create_by(xbrl_name: 'RealEstateRevenueNet')
        si.xbrl_names.find_or_create_by(xbrl_name: 'LicensesRevenue')
        si.xbrl_names.find_or_create_by(xbrl_name: 'LicenseAndServicesRevenue')
        si.xbrl_names.find_or_create_by(xbrl_name: 'ElectricUtilityRevenue')

      when 'Cost of Revenue, Total'
        si.xbrl_names.find_or_create_by(xbrl_name: 'CostsAndExpenses')
        si.xbrl_names.find_or_create_by(xbrl_name: 'CostOfGoodsSold')
        si.xbrl_names.find_or_create_by(xbrl_name: 'CostOfRevenue')
        si.xbrl_names.find_or_create_by(xbrl_name: 'CostOfGoodsAndServicesSold')
        si.xbrl_names.find_or_create_by(xbrl_name: 'CostOfServices')
        si.xbrl_names.find_or_create_by(xbrl_name: 'OperatingCostsAndExpenses')
        si.xbrl_names.find_or_create_by(xbrl_name: 'LicenseCosts')
        si.xbrl_names.find_or_create_by(xbrl_name: 'CostOfPurchasedOilAndGas')

      when 'Gross Profit'
      when 'Selling/General/Admin. Expenses, Total'
      when 'Research & Development'
      when 'Depreciation/Amortization'
      when 'Interest Expense(Income) - Net Operating'
      when 'Unusual Expense (Income)'
      when 'Other Operating Expenses, Total'
      when 'Total Operating Expense'
      when 'Operating Income'
      when 'Interest Income(Expense), Net Non-Operating'
      when 'Gain (Loss) on Sale of Assets'
      when 'Other, Net'
      when 'Income Before Tax'
      when 'Income After Tax'
      when 'Minority Interest'
      when 'Equity In Affiliates'
      when 'Net Income Before Extra. Items'
      when 'Accounting Change'
      when 'Discontinued Operations'
      when 'Extraordinary Item'
      when 'Net Income'
        si.xbrl_names.find_or_create_by(xbrl_name: 'NetIncomeLoss')
        si.xbrl_names.find_or_create_by(xbrl_name: 'ProfitLoss')

      when 'Preferred Dividends'
      when 'Income Available to Common Excl. Extra Items'
      when 'Income Available to Common Incl. Extra Items'
      when 'Basic Weighted Average Shares'
      when 'Basic EPS Excluding Extraordinary Items'
      when 'Basic EPS Including Extraordinary Items'
      when 'Dilution Adjustment'
      when 'Diluted Weighted Average Shares'
      when 'Diluted EPS Excluding Extraordinary Items'
      when 'Diluted EPS Including Extraordinary Items'
      when 'Dividends per Share - Common Stock Primary Issue'
      when 'Gross Dividends - Common Stock'
      when 'Net Income after Stock Based Comp. Expense'
      when 'Basic EPS after Stock Based Comp. Expense'
      when 'Diluted EPS after Stock Based Comp. Expense'
      when 'Depreciation, Supplemental'
      when 'Total Special Items'
      when 'Normalized Income Before Taxes'
      when 'Effect of Special Items on Income Taxes'
      when 'Income Taxes Ex. Impact of Special Items'
      when 'Normalized Income After Taxes'
      when 'Normalized Income Avail to Common'
      when 'Basic Normalized EPS'
      when 'Diluted Normalized EPS'
      when 'Cash & Equivalents'
      when 'Short Term Investments'
      when 'Cash and Short Term Investments'
      when 'Accounts Receivable - Trade, Net'
      when 'Receivables - Other'
      when 'Total Receivables, Net'
      when 'Total Inventory'
      when 'Prepaid Expenses'
      when 'Other Current Assets, Total'
      when 'Total Current Assets'
      when 'Property/Plant/Equipment, Total - Gross'
      when 'Accumulated Depreciation, Total'
      when 'Goodwill, Net'
      when 'Intangibles, Net'
      when 'Long Term Investments'
      when 'Other Long Term Assets, Total'
      when 'Total Assets'
      when 'Accounts Payable'
      when 'Accrued Expenses'
      when 'Notes Payable/Short Term Debt'
      when 'Current Port. of LT Debt/Capital Leases'
      when 'Other Current liabilities, Total'
      when 'Total Current Liabilities'
      when 'Long Term Debt'
      when 'Capital Lease Obligations'
      when 'Total Long Term Debt'
      when 'Total Debt'
      when 'Deferred Income Tax'
      when 'Other Liabilities, Total'
      when 'Total Liabilities'
      when 'Redeemable Preferred Stock, Total'
      when 'Preferred Stock - Non Redeemable, Net'
      when 'Common Stock, Total'
      when 'Additional Paid-In Capital'
      when 'Retained Earnings (Accumulated Deficit)'
      when 'Treasury Stock - Common'
      when 'Other Equity, Total'
      when 'Total Equity'
      when 'Total Liabilities & Shareholders\' Equity'
      when 'Shares Outs - Common Stock Primary Issue'
      when 'Total Common Shares Outstanding'
      when 'Net Income/Starting Line'
      when 'Depreciation/Depletion'
      when 'Amortization'
      when 'Deferred Taxes'
      when 'Non-Cash Items'
      when 'Changes in Working Capital'
      when 'Cash from Operating Activities'
      when 'Capital Expenditures'
      when 'Other Investing Cash Flow Items, Total'
      when 'Cash from Investing Activities'
      when 'Financing Cash Flow Items'
      when 'Total Cash Dividends Paid'
      when 'Issuance (Retirement) of Stock, Net'
      when 'Issuance (Retirement) of Debt, Net'
      when 'Cash from Financing Activities'
      when 'Foreign Exchange Effects'
      when 'Net Change in Cash'
      when 'Cash Interest Paid, Supplemental'
      when 'Cash Taxes Paid, Supplemental'

      end
    end
  end
end
