cd C:\Users\rqs0401\Desktop\20160517_1.7mHz
FOR /L %%O IN (0, 1, 3) DO (
	FOR /L %%D IN (0, 1, 99) DO (
		if %%D LEQ 9 (
		copy "%%O.0%%DMHz\Pos0\img_000000000_Default_000.tif" images\%%O.0%%D.tif
		)
		else (
		copy "%%O.%%DMHz\Pos0\img_000000000_Default_000.tif" images\%%O.%%D.tif
		)
	)
)