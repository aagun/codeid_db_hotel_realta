-- File insert 

-- use this if you want create table without relation first and comment alter
-- alter table hr.work_order_detail add constraint fk_wode_emp_id foreign key(wode_emp_id) references hr.employee(emp_id);
-- alter table hr.work_order_detail add constraint fk_wode_seta_id foreign key(wode_seta_id) references master.service_task(seta_id);
-- alter table hr.work_order_detail add foreign key(wode_faci_id) references hotel.facilites(faci_id);

-- insert dummy data
--SET IDENTITY_INSERT hr.regions ON;
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('1','1995-01-14', '2');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('2','1995-02-09', '2');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('3','1995-03-17', '2');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('4','1995-04-03', '3');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('5','1995-07-12', '2');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('6','1995-08-19', '5');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('7','1995-09-17', '4');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('8','1995-11-20', '5');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('9','1995-12-23', '5');
--Insert into HR.work_orders (woro_id,woro_date, woro_user_id) values ('10','1995-12-27', '4');
--SET IDENTITY_INSERT hr.regions OFF;

--SET IDENTITY_INSERT hr.regions ON;
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('1', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('2', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('3', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('4', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('5', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('6', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('7', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('8', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('9', '', '', '', '', '', '', '', '', '');
--Insert into HR.work_order_detail (wode_id, wode_task_name, wode_status, wode_start_date, wode_end_date, wode_notes, wode_emp_id, wode_seta_id, wode_faci_id) values ('10', '', '', '', '', '', '', '', '', '');
--SET IDENTITY_INSERT hr.regions OFF;

