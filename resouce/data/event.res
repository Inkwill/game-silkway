name	objtype	pattern
dynasty_establish	figure	obj[0].establish(param[0],param[1],date);obj[0].test(param[1])
dynasty_perish	dynasty	obj[0].perish(date)
dynasty_inherit	figure;figure	obj[1].inherit(obj[0])
move_capital	dynasty	obj[0].move_capital(param[0])
test	figure	obj[0].test(param[0])
population_increase	aeroer	obj[0].increase_population()
