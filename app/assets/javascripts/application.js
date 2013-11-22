// //= require jquery
// //= require jquery_ujs
//= require foundation
// //= require_tree .

$(document).foundation();

if ($('#shortcut_shortcut').length > 0) {
	var MakeClearWhatIsHappening = {
	now: function(event) {
	  var shortcut = $('#shortcut_shortcut').val();
	  var url = $('#shortcut_url').val();
	  if (url === 'http://') url += '?';
	  if (shortcut.length == 0) shortcut = '?';
	  if (url.length == 0) url = '?';
	  $('#notes_to_user').html("When you go to <strong>" + window.location.protocol + "//" + window.location.host + "/" + shortcut + "</strong> in your browser, you will be taken to <strong>" + url + "</strong>");
	}
	}

	MakeClearWhatIsHappening.now();

	$('#shortcut_shortcut').focus();

	$('#shortcut_shortcut').on('keyup', MakeClearWhatIsHappening.now);
	$('#shortcut_url').on('keyup', MakeClearWhatIsHappening.now);
}
