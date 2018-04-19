private void ExportExcel() // xuat du lieu mau excel de import
        {
            try
            {
                DataTable dtExcel = new DataTable();
                gridControl_Excel.DataSource = null;
                dtExcel.Columns.Add("MaSV", typeof(string));
                dtExcel.Columns.Add("MaLHP", typeof(string));
                
                #region Tạo dữ liệu mẫu
                dtExcel.Rows.Add(new Object[] { "123456"
                    , "1620010"
                    });

                dtExcel.Rows.Add(new Object[] { "123456"
                    , "1620011"
                    });

                #endregion

                #region Xuất excel
                gridControl_Excel.DataSource = dtExcel;
                for (int i = 0; i < gridView_Excel.Columns.Count; i++)
                {
                    gridView_Excel.Columns[i].Visible = true;
                    gridView_Excel.Columns[i].Caption = gridView_Excel.Columns[i].FieldName.Trim();
                }
                #endregion

                SaveFileDialog sfdFiles = new SaveFileDialog();
                sfdFiles.Filter = "(*.xls)|*xls";
                sfdFiles.FileName = "UIS-MauImportSinhVienLHP";
                if (sfdFiles.ShowDialog() == DialogResult.OK && sfdFiles.FileName != string.Empty)
                {
                    try
                    {
                        gridControl_Excel.ExportToXls(sfdFiles.FileName + ".xls");
                        PscMessage.Show("Bạn đã xuất file thành công.", "UIS - Thông báo", ListButton.Close, ICon.Success);
                        Schedule.CommonLibS.Functions.OpenFile(sfdFiles.FileName + ".xls");
                    }
                    catch (Exception ex)
                    {
                        DevExpress.XtraEditors.XtraMessageBox.Show(ex.Message, "Message", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
            catch { }
        }