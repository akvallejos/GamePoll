function add_new_game_button(){
	$('#new_game').button().click(function(){
		$('#new_game_form').remove(); //prevents form from opening more than once
		$.get('/games/new', function(html){
			$('body').append(html);
			$('#new_game_form').dialog({'modal': 'true'});
		});
	});
}

function adjust_height_of_li(){
	var max_height = 0;
	$('.game').each(function(item){
		var height = $(this).css('height').replace(/px/, '');
		if(max_height < height) { max_height = height; }
	});

	$('.game').each(function(item){
		$(this).css('height', max_height);
	});
}