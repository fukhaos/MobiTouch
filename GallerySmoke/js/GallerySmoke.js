/*


*/

;(function ( $, window, undefined ) {
    var pluginName = 'gallerySmoke',
        document = window.document,
        defaults = {
            btnPrev : ".prev",
            btnNext : ".next",
            width : "auto",
            height : "auto",
            center: true,
            swipe: true,
            hitEdge: false
        };

    function Plugin( element, options ) {

        this.element = element;
        this.options = $.extend( {}, defaults, options) ;
 
        this._defaults = defaults;
        this._name = pluginName;
        
        isto = this;

        this.init();
    }

    Plugin.prototype.init = function () {

      var 
        $doc = $(document),
        $win = $(window),
        opcao = this.options,
        qtd = $(isto.element).find("li").length,
        retrato = false,
        _wCarouselTotal = 0,
        fotoAtual = 0,
        wCarrosel = 0,
        prev = $(opcao.btnPrev),
        next = $(opcao.btnNext);


        carrosel = {
          init: function(){
            $(isto.element).find("ul").addClass("carrosel");
            $(isto.element).find("li").css({"float":"left"});
            $(isto.element).find("img").css({width:"100%",height:"100%"});
            $(".carrosel").css({"display":"block"});

            $win.resize(function() {
              carrosel.autoAjuste(false);
            });

            carrosel.autoAjuste(false);
            
            $('.carrosel img').eq(0).load(function(){
              $("this").height();
              $("this").width();
              carrosel.autoAjuste(false);
            });

            prev.click(function (e) {
              e.preventDefault();
              carrosel.buttonPrev()
            });

            next.click(function (e) {
              e.preventDefault()
              carrosel.buttonNext()
            });
            prev.fadeOut()        

            $doc.keydown(function(event) {
                switch (event.keyCode) {
                  case 37: carrosel.buttonPrev(); break;
                  case 39: carrosel.buttonNext(); break;
                }
            });


            if(opcao.swipe){
              $(isto.element).swipe({
                swipeRight: function(result) { carrosel.buttonPrev() },
                swipeLeft: function(result) { carrosel.buttonNext() }
              });
            }

            //
            $(".carrosel a").append("<span>")
            $(".carrosel span").css({opacity:"0"})

          },
          autoAjuste: function(anime){

          var  _wCarousel = (opcao.width == "auto") ? $win.width() : opcao.width;
          var  _hCarousel = (opcao.height == "auto") ? $win.height() : opcao.height;

            alvo = 0;

            for (var i = 0; i < qtd; i++) {
              var screenImage = $(isto.element).find("img").eq(i);
              var theImage = new Image();
              theImage.src = screenImage.attr("src")

              var imageWidth = theImage.width;
              var imageHeight = theImage.height;

              var px = _wCarousel / imageWidth;
              var py = _hCarousel / imageHeight;
              var div = (opcao.hitEdge) ? Math.max(px,py) : Math.min(px,py);
              
              $(isto.element).find("li").eq(i).css({
                "width": Math.floor(imageWidth * div),
                "height":Math.floor( imageHeight * div)
              })

              _wCarouselTotal += $(isto.element).find("img").eq(i).width();
            };

            $(".carrosel").css({"width":_wCarouselTotal});

            for (var ii = 0;ii < fotoAtual; ii++) {
              alvo += $(".carrosel li").eq(ii).width()
            };

            if (opcao.center) {
              alvo = alvo - (_wCarousel / 2) + ($(".carrosel img").eq(fotoAtual).width() / 2)
            };

            if(anime){
              $(".carrosel")
                .stop()
                .animate({"marginLeft":-alvo},
                {duration: 600, easing: "easeInOutExpo"}
              );
            }else{
              $(".carrosel").css({"marginLeft":-alvo});
            }

            $(".carrosel li").stop().animate({"opacity":.2}).removeClass("fotoAtual");
            $(".carrosel li").eq(fotoAtual).stop().animate({"opacity":1}).addClass("fotoAtual");

            //Alinha Seta
            //Não e da galeria
            var alinha_seta = (($doc.width()-$('.fotoAtual').width())/2);
            alinha_seta     = parseInt(alinha_seta);

            var seta_next = (alinha_seta-75);
            var seta_prev = (alinha_seta + $('.fotoAtual').width()+5);

            prev.stop().animate({left:seta_next,opacity:1});
            next.stop().animate({left:seta_prev,opacity:1});

            //referencia
            //Não e da galeria
            $(".referencia").empty().append("<span>Referência</span>: " + $('.carrosel img').eq(fotoAtual).attr("alt"));


          },
          buttonNext: function(e){
            console.log(fotoAtual)
            if(fotoAtual < qtd - 1){
              fotoAtual++
              carrosel.autoAjuste(true)
              prev.fadeIn()
              if(fotoAtual == qtd - 1){
                next.fadeOut()  
              }
            }
            return false
            e.preventDefault();
          },
          buttonPrev: function(e){
            if(fotoAtual > 0){
              fotoAtual--
              carrosel.autoAjuste(true)
              next.fadeIn()
              if(fotoAtual < 1){
                prev.fadeOut()
              }
            }
            return false
            e.preventDefault();
          }
        }

        carrosel.init()

    };

    $.fn[pluginName] = function ( options ) {
        return this.each(function () {
            if (!$.data(this, 'plugin_' + pluginName)) {
                $.data(this, 'plugin_' + pluginName, new Plugin( this, options ));
            }
        });
    };

}(jQuery, window));