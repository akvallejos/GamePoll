//ballots.js

function createRandomVoteBallot(player_name)
{
	var html = $('.ballot_form').clone();

	$('input[type=checkbox]', '.ballot_form').each(function(){
		$(this).attr('name', 'poll[' + player_name + '][][game_id]');
	});


	$('.ballot_entry').removeClass('ballot_form');
	$('.players_auto_complete', html).val('');
	$('input[type=checkbox]', html).each(function(){
		$(this).removeAttr('checked');
	});
	$('form').prepend(html);

	$('.players_auto_complete', '.ballot_form').autocomplete({source: players});
	$('td').tooltip({position: {my: "center bottom",at: "center top"}}).animate(0);

	$('input:submit').button({disabled: false});
}

function createRankedVoteBallot(player_name)
{
	var html = $('.ballot_form').clone();
	
	$('.ui-droppable li', '.ballot_form').each(function(){
		if($(this).hasClass('placeholder')){ return true; }
		var game = $(this).attr('value')
		$(this).append('<input type=hidden name=poll[' + player_name + '][][game_id] value="' + game +'"></input>');
	});
	
	$('.ballot_entry').removeClass('ballot_form');
	$('.players_auto_complete', html).val('');
	$('.droppable_sortable_games li', html).each(function(){
		if($(this).hasClass('placeholder')) { return true; }
		$('.draggable_games ul', html).append(this);
	});
	$('.placeholder', html).show();
	
	sortList($('.draggable_games ul', html));
	
	$('form').prepend(html);
	addDraggableDroppable();
	$('.players_auto_complete', '.ballot_form').autocomplete({source: players});
	$('td').tooltip({position: {my: "center bottom",at: "center top"}}).animate(0);
	
	$('input:submit').button({disabled: false});
	
}

function sortList(mylist)
{
	var listitems = mylist.children('li').get();
	listitems.sort(function(a, b) {
	   return $(a).text().toUpperCase().localeCompare($(b).text().toUpperCase());
	})
	$.each(listitems, function(idx, itm) { mylist.append(itm); });
	return mylist;
}

function addDraggableDroppable(){
	$('li').tooltip({position: {my: "center bottom",at: "center top"}}).animate(0);
	$('li', '.draggable_games').draggable( {revert: true, helper:"clone"});
	$( ".droppable_sortable_games" ).droppable({
	      activeClass: "ui-state-default",
	      hoverClass: "ui-state-hover",
	      accept: ":not(.ui-sortable-helper)",
	      drop: function( event, ui ) {
	        $( 'ol', this ).find( ".placeholder" ).hide();
	        $( ui.draggable ).appendTo( 'ol', this );
	      }
	    }).sortable({
	      items: "li:not(.placeholder)",
	      sort: function() {
	        // gets added unintentionally by droppable interacting with sortable
	        // using connectWithSortable fixes this, but doesn't allow you to customize active/hoverClass options
	        $( this ).removeClass( "ui-state-default" );
					$( this ).removeClass( "ui.draggable")
	      }
	    });
}