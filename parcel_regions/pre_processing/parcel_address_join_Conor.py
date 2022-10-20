import arcpy
from arcpy import env
from datetime import datetime
arcpy.env.overwriteOutput = True


env.workspace = 'K:\DataServices\Datasets\Town_Data\_Land_Parcel_Database\Processing\parcels_with_address_counts.gdb'
outgdb = 'K:\DataServices\Datasets\Town_Data\_Land_Parcel_Database\Processing\parcels_with_address_counts.gdb'
outcsv = 'K:\DataServices\Datasets\Town_Data\_Land_Parcel_Database\Processing'


d1 = datetime.today().strftime('%Y%m%d')

infc = ["address_pts","L3_TAXPAR_POLY_" + d1]
#arcpy.analysis.PairwiseIntersect(infc, "address_parcel_inter", "ALL", None, "INPUT")
print('Intersect Complete')

arcpy.AddField_management("address_parcel_inter", "addr_cnt", "LONG") 
arcpy.CalculateField_management("address_parcel_inter", "addr_cnt", "1", "PYTHON3")

arcpy.analysis.Statistics("address_parcel_inter", "parcel_addr_cnt_sum", [["addr_cnt","SUM"]], "LOC_ID")
print('Summary Table Export Complete')

arcpy.management.AddJoin("L3_TAXPAR_POLY_20220621", "LOC_ID", "parcel_addr_cnt_sum", "LOC_ID", "KEEP_ALL", "NO_INDEX_JOIN_FIELDS")
print('Join Complete')

arcpy.conversion.FeatureClassToFeatureClass("L3_TAXPAR_POLY_20220621", outgdb, "ma_parcels_with_address_counts_" + d1)
print('Feature Export Complete')

arcpy.conversion.TableToTable("address_parcel_inter", outcsv, "address_parcel_inter_" + d1 + ".csv")
arcpy.conversion.TableToTable("ma_parcels_with_address_counts", outcsv, "ma_parcels_with_address_counts_" + d1 + ".csv")
print('Table Exports Complete')
