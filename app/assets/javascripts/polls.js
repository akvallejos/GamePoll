//polls.js

function add_new_poll_button(voting){
	//alert(voting);
	$('#new_poll_' + voting ).button().click(function(){
		$('#new_poll_form').remove(); //prevents form from opening more than once
		$.get('/polls/new?voting=' + voting, function(html){
			$('body').append(html);
			$('#new_poll_form').dialog({'modal':'true', 'width': 700});
		});
	});
}

function add_new_ballot_button(){
	$('.new_ballot_button').button().click(function(){
		
		var player_name = $('[name="poll[ballot][][player_name]"]', '.ballot_form').val();
		
		if(player_name != '')
		{
			var voting = $('#poll_voting').val();
			alert( voting );
			
			if(voting === "undefined")
			{
				createRandomVoteBallot(player_name);
			}
			else if(voting == "ranked")
			{
				createRankedVoteBallot(player_name);
			}

		}
		else
		{
			alert('Name cannot be blank!')
		}
	});
}

