window['__onGCastApiAvailable'] = function(isAvailable) {
    if (isAvailable) {
        cast.framework.CastContext.getInstance().setOptions({
          receiverApplicationId: chrome.cast.media.DEFAULT_MEDIA_RECEIVER_APP_ID
        });

        cast.framework.CastContext.getInstance().addEventListener(cast.framework.CastContextEventType.CAST_STATE_CHANGED, function({ castState }) {
            if (castState === 'CONNECTED') {
                const mediaInfo = new chrome.cast.media.MediaInfo(window.mediaStream, 'video/mp4');
                const request = new chrome.cast.media.LoadRequest(mediaInfo);

                cast.framework.CastContext.getInstance().getCurrentSession().loadMedia(request).then(
                  function() {
                    console.log('Cast media loaded');
                  },
                  function(errorCode) {
                    console.log(errorCode);
                });
            }
        });
    }
}