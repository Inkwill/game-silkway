name	objtype	pattern
establish	figure	obj[0].establish(param[0],param[1]);obj[0].test(param[1])
morarch_dead	figure;figure	obj[1].inherit(obj[0]);obj[0].dead()
nothing	figure	obj[0].test(param[0])
