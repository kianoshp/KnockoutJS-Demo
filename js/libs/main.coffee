###
Flickr API Key 8d9583006d90062b6c64640bcfccb69c
Secret f8366434247ac7c1
###
flickrURL = 'http://api.flickr.com/services/rest/?format=json&nojsoncallback=1&method=flickr.photos.search&api_key=8d9583006d90062b6c64640bcfccb69c&per_page=25&tags='

Photo = (id, owner, title, farmId, serverId, secret, ispublic, isfriend, isfamily) -> 
	@id = id
	@owner = owner
	@title = title
	@farmId = farmId
	@serverId = serverId
	@secret = secret
	@ispublic = ispublic
	@isfriend = isfriend
	@isfamily = isfamily
	return 

Favorites = (Photo) ->
	@Photo = Photo

photoViewModel = {
	photos: ko.observableArray([])
	favorites: ko.observableArray([])
	getPhotos: (formElement) -> 
		console.log "getting photos with tags --> " + $(formElement).find('#search').val()
		#empty the results first
		photoViewModel.photos([])

		searchTag = $(formElement).find('#search').val()
		that = @
		$.getJSON(flickrURL + searchTag
		).done (photoData) ->
			console.log "I got the data"
			_.each photoData.photos.photo, (photo) ->
				image = {
					photoObj: new Photo(photo.id, 
										photo.owner, 
										photo.title, 
										photo.farm, 
										photo.server, 
										photo.secret, 
										photo.ispublic, 
										photo.isfriend, 
										photo.isfamily),
					photoSrc: that.createSrc photo.farm, photo.server, photo.id, photo.secret, 'thumbnail'
				}
				that.photos.push image
		return

	createSrc: (farmId, serverId, id, secret, size) ->
		return 'http://farm' + farmId + '.staticflickr.com/' + serverId + '/' + id + '_' + secret + (if size is "thumbnail" then "_s.jpg" else "_n.jpg")

	addToFavorites: (id) ->
		currentPhotoObj = _.find(photoViewModel.photos(), (photo) ->
				photo.photoObj['id'] == id
			)
		favoriteExists = _.find(photoViewModel.favorites(), (favorite) ->
				favorite.photoObj['id'] == currentPhotoObj.photoObj.id
			)
		if(!favoriteExists)
			photoViewModel.favorites.push currentPhotoObj
		return

	removeFromFavorites: (id) ->
		photoViewModel.favorites.splice _.indexOf(photoViewModel.favorites(), 	_.find(photoViewModel.favorites(), (favorite) ->
				favorite.photoObj['id'] == id
			)), 1

	showLargerImage: (id) ->
		currentPhotoObj = _.find(photoViewModel.photos(), (photo) ->
				photo.photoObj['id'] == id
			)

		imageSrc = photoViewModel.createSrc currentPhotoObj.photoObj.farmId, currentPhotoObj.photoObj.serverId, currentPhotoObj.photoObj.id, currentPhotoObj.photoObj.secret, 'large'

		$('body').modal({height: 'auto', width: 'auto', loaderImgSrc: 'img/loader.gif', showSpinner: false})
		$('body').modal('openModal')
		$('body').modal('updateContent', $('<img/>')
			.attr('src', imageSrc))

}

ko.applyBindings photoViewModel

