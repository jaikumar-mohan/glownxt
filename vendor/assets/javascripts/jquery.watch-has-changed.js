// Written by Luke Morton, licensed under MIT
(function ($) {
 
	$.fn.watchChanges = function () {
		return this.each(function () {
			$.data(this, 'formHash', $(this).serialize());
		});
	};

	$.fn.reset_form = function(fn) {
	  $(this).each (function() { this.reset(); });
	};
 
	$.fn.hasChanged = function () {
		var hasChanged = false;
 
		this.each(function () {
			var formHash = $.data(this, 'formHash');
 
			if (formHash != null && formHash !== $(this).serialize()) {
				hasChanged = true;
				return false;
			}
		});
 
		return hasChanged;
	};
 
}).call(this, jQuery);