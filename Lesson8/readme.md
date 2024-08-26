```create table default.test_dq engine = MergeTree
order by
dt_hour as
SELECT
	toStartOfHour(dt) dt_hour,
	count() cnt,
	uniq(shk_id) qty_shk_id,
	uniq(ext_id) qty_ext_id,
	sum(is_found) qty_is_found,
	sum(is_valid) qty_is_valid,
	sum(is_verified) qty_is_verified,
	sum(is_realizable) qty_is_realizable
FROM
	ShkExciseCrpt_log
group by
	dt_hour;
