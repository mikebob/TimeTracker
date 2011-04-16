var Timer = function (callback) {
    var _interval;
	var _ticks;

    // ctor
    new function Timer(){
		this._ticks = 0;
		this._interval = null;
	}

    // public methods
    this.Start=function(){
		this._interval = setInterval(callback, 1000);
    }
    
    this.Stop=function(){
		clearInterval(_interval);
    }
    
    // private methods
    function getDuration(){
        return Math.floor(_ticks / 1000);
    }

	function getSeconds() {
		return (getDuration % 60);
	}

	function getMinutes() {
		return Math.floor(getDuration / 60);
	}

};
