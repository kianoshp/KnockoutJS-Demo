$ ->
	###
	$('#results').delegate('div img', 'mouseover mouseout', (e) ->
		thisId = @.id
		if(e.type == 'mouseover')
			imageWidth = $(@).width()
			imageHeight = $(@).height()
			$('<div/>')
				.appendTo($(@).parent('div'))
				.attr('id', 'moreInfo_' + thisId)
				.width(imageWidth)
				.height(imageHeight)
				.addClass('moreInfo')
			$('<img/>')
				.attr('src', 'img/fav-icon-sketch.png')
				.attr('width', '25%')
				.appendTo($('#moreInfo_' + thisId))
			$('#moreInfo_' + thisId)
				.stop()
				.animate({left: 0}, {queue: false, duration: 500})
			console.log 'I have entered the image'
		else if (e.type == 'mouseout')
			$('#moreInfo_' + thisId)
				.stop()
				.animate({left: 100}, {queue: false, duration: 500})
			$('#moreinfo_' + thisId).remove()
			console.log 'I have exited the image'
	)###