(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-97628929-2', 'auto');
ga('send', 'pageview');

$(document).ready(function() {
    $("#ageSlider").ionRangeSlider({
            values: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, "80+"]
    });
});

$(document).on('change', '#taSelection', function(e) {
	ga('send', 'event', 'widget', 'taSelect', $(e.currentTarget).val());
});

$(document).on('change', '#disabilityMeasure', function(e) {
	ga('send', 'event', 'widget', 'disabSelect', $(e.currentTarget).val());
});

$(document).on('change', '#ageSlider', function(e) {
	var timer;
	clearTimeout(timer);
	timer = setTimeout(function() {ga('send', 'event', 'widget', 'ageSelect', $(e.currentTarget).val())}, 2000);
});