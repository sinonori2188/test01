$(function () {
	$('div.toggle1').next().show();
	$('div.toggle1').toggleClass('topic2show');

	$('div.toggle2').next().hide();
	$('div.toggle2').toggleClass('topic2hide');

	$('div.toggle1').click(function() {
	    $(this).next().slideToggle('fast');
		$(this).toggleClass('topic2show topic2hide');
	});
	$('div.toggle2').click(function() {
	    $(this).next().slideToggle('fast');
		$(this).toggleClass('topic2hide topic2show');
	});
});
