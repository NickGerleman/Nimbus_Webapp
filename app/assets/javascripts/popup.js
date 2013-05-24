/*! Magnific Popup - v0.8.2 - 2013-05-05
 * http://dimsemenov.com/plugins/magnific-popup/
 * Copyright (c) 2013 Dmitry Semenov;
 * Slightly modified by Nick Gerleman */

(function ($)
    {

        /*>>core*/

        /**
         * Private static constants
         */
        var CLOSE_EVENT = 'Close', BEFORE_APPEND_EVENT = 'BeforeAppend', MARKUP_PARSE_EVENT = 'MarkupParse', OPEN_EVENT = 'Open', CHANGE_EVENT = 'Change', NS = 'mfp', EVENT_NS = '.' + NS, READY_CLASS = 'mfp-ready', REMOVING_CLASS = 'mfp-removing', PREVENT_CLOSE_CLASS = 'mfp-prevent-close';

        /**
         * Private vars
         */
        var mfp, // As we have only one instance of MagnificPopup object, we define it locally to not to use 'this'
            MagnificPopup = function ()
                {
                }, _prevStatus, _window = $(window), _body, _document, _prevContentType, _wrapClasses, _currPopupType;

        /**
         * Private functions
         */
        var _mfpOn = function (name, f)
            {
                mfp.ev.on(NS + name + EVENT_NS, f);
            }, _getEl = function (className, appendTo, html, raw)
            {
                var el = document.createElement('div');
                el.className = 'mfp-' + className;
                if (html)

                    el.innerHTML = html;

                if (!raw)
                    {
                        el = $(el);
                        if (appendTo)

                            el.appendTo(appendTo);

                    } else if (appendTo)

                    appendTo.appendChild(el);

                return el;
            }, _mfpTrigger = function (e, data)
            {
                mfp.ev.triggerHandler(NS + e, data);

                if (mfp.st.callbacks)
                    {
                        // converts "mfpEventName" to "eventName" callback and triggers it if it's present
                        e = e.charAt(0).toLowerCase() + e.slice(1);
                        if (mfp.st.callbacks[e])
                            {
                                mfp.st.callbacks[e].apply(mfp, $.isArray(data) ? data : [data]);
                            }
                    }
            }, _setFocus = function ()
            {
                (mfp.st.focus ? mfp.content.find(mfp.st.focus).eq(0) : mfp.wrap).focus();
            }, _getCloseBtn = function (type)
            {
                if (type !== _currPopupType || !mfp.currTemplate.closeBtn)
                    {
                        mfp.currTemplate.closeBtn = $(mfp.st.closeMarkup.replace('%title%', mfp.st.tClose));
                        _currPopupType = type;
                    }
                return mfp.currTemplate.closeBtn;
            };

        /**
         * Public functions
         */
        MagnificPopup.prototype = {

            constructor: MagnificPopup,

            /**
             * Initializes Magnific Popup plugin.
             * This function is triggered only once when $.fn.magnificPopup or $.magnificPopup is executed
             */
            init: function ()
                {
                    var appVersion = navigator.appVersion;
                    mfp.isAndroid = (/android/gi).test(appVersion);
                    mfp.isIOS = (/iphone|ipad|ipod/gi).test(appVersion);

                    // We disable fixed positioned lightbox on devices that don't handle it nicely.
                    // If you know a better way of detecting this - let me know.
                    mfp.probablyMobile = (mfp.isAndroid || mfp.isIOS || /(Opera Mini)|Kindle|webOS|BlackBerry|(Opera Mobi)|(Windows Phone)|IEMobile/i.test(navigator.userAgent) );
                    _body = $(document.body);
                    _document = $(document);

                    mfp.popupsCache = {};
                },

            /**
             * Opens popup
             * @param  data [description]
             */
            open: function (data)
                {

                    if (mfp.isOpen) return;

                    var i;

                    mfp.types = [];
                    _wrapClasses = '';

                    mfp.ev = data.el || _document;

                    if (data.isObj)

                        mfp.index = data.index || 0; else
                        {
                            mfp.index = 0;
                            var items = data.items, item;
                            for (i = 0; i < items.length; i++)
                                {
                                    item = items[i];
                                    if (item.parsed)

                                        item = item.el[0];

                                    if (item === data.el[0])
                                        {
                                            mfp.index = i;
                                            break;
                                        }
                                }
                        }

                    if (data.key)
                        {
                            if (!mfp.popupsCache[data.key])

                                mfp.popupsCache[data.key] = {};

                            mfp.currTemplate = mfp.popupsCache[data.key];
                        } else

                        mfp.currTemplate = {};

                    mfp.st = $.extend(true, {}, $.magnificPopup.defaults, data);
                    mfp.fixedContentPos = mfp.st.fixedContentPos === 'auto' ? !mfp.probablyMobile : mfp.st.fixedContentPos;

                    mfp.items = data.items.length ? data.items : [data.items];

                    // Building markup
                    // main containers are created only once
                    if (!mfp.bgOverlay)
                        {

                            // Dark overlay
                            mfp.bgOverlay = _getEl('bg').on('click' + EVENT_NS, function ()
                            {
                                mfp.close();
                            });

                            mfp.wrap = _getEl('wrap').attr('tabindex', -1).on('click' + EVENT_NS, function (e)
                            {

                                var target = e.target;
                                if ($(target).hasClass(PREVENT_CLOSE_CLASS))

                                    return;

                                if (mfp.st.closeOnContentClick)

                                    mfp.close(); else

                                // close popup if click is not on a content, on close button, or content does not exist
                                if (!mfp.content || $(target).hasClass('mfp-close') || (mfp.preloader && e.target === mfp.preloader[0]) || (target !== mfp.content[0] && !$.contains(mfp.content[0], target)))

                                    mfp.close();

                            });

                            mfp.container = _getEl('container', mfp.wrap);
                        }

                    mfp.contentContainer = _getEl('content');
                    if (mfp.st.preloader)

                        mfp.preloader = _getEl('preloader', mfp.container, mfp.st.tLoading);

                    // Initializing modules
                    var modules = $.magnificPopup.modules;
                    for (i = 0; i < modules.length; i++)
                        {
                            var n = modules[i];
                            n = n.charAt(0).toUpperCase() + n.slice(1);
                            mfp['init' + n].call(mfp);
                        }
                    _mfpTrigger('BeforeOpen');

                    // Close button
                    if (!mfp.st.closeBtnInside)

                        mfp.wrap.append(_getCloseBtn()); else
                        {
                            _mfpOn(MARKUP_PARSE_EVENT, function (e, template, values, item)
                            {
                                values.close_replaceWith = _getCloseBtn(item.type);
                            });
                            _wrapClasses += ' mfp-close-btn-in';
                        }

                    if (mfp.st.alignTop)

                        _wrapClasses += ' mfp-align-top';

                    if (mfp.fixedContentPos)
                        {
                            mfp.wrap.css({
                                overflow: mfp.st.overflowY,
                                overflowX: 'hidden',
                                overflowY: mfp.st.overflowY
                            });
                        } else
                        {
                            mfp.wrap.css({
                                top: _window.scrollTop(),
                                position: 'absolute'
                            });
                        }
                    if (mfp.st.fixedBgPos === false || (mfp.st.fixedBgPos === 'auto' && !mfp.fixedContentPos))
                        {
                            mfp.bgOverlay.css({
                                height: _document.height(),
                                position: 'absolute'
                            });
                        }

                    // Close on ESC key
                    _document.on('keyup' + EVENT_NS, function (e)
                    {
                        if (e.keyCode === 27)

                            mfp.close();

                    });

                    _window.on('resize' + EVENT_NS, function ()
                    {
                        mfp.updateSize();
                    });

                    if (!mfp.st.closeOnContentClick)
                        {
                            _wrapClasses += ' mfp-auto-cursor';
                        }

                    if (_wrapClasses)
                        mfp.wrap.addClass(_wrapClasses);

                    // this triggers recalculation of layout, so we get it once to not to trigger twice
                    var windowHeight = mfp.wH = _window.height();

                    var bodyStyles = {};

                    if (mfp.fixedContentPos)
                        bodyStyles.overflow = 'hidden';

                    var classesToadd = mfp.st.mainClass;
                    if (classesToadd)
                        {
                            mfp._addClassToMFP(classesToadd);
                        }

                    // add content
                    mfp.updateItemHTML();

                    // remove scrollbar, add padding e.t.c
                    _body.css(bodyStyles);

                    // add everything to DOM
                    mfp.bgOverlay.add(mfp.wrap).prependTo(document.body);

                    // Save last focused element
                    mfp._lastFocusedEl = document.activeElement;

                    // Wait for next cycle to allow CSS transition
                    setTimeout(function ()
                    {

                        if (mfp.content)
                            {
                                mfp._addClassToMFP(READY_CLASS);
                                _setFocus();
                            } else

                        // if content is not defined (not loaded e.t.c) we add class only for BG
                            mfp.bgOverlay.addClass(READY_CLASS);

                        // Trap the focus in popup
                        _document.on('focusin' + EVENT_NS, function (e)
                        {
                            if (e.target !== mfp.wrap[0] && !$.contains(mfp.wrap[0], e.target))
                                {
                                    _setFocus();
                                    return false;
                                }
                        });

                    }, 16);

                    mfp.isOpen = true;
                    mfp.updateSize(windowHeight);
                    _mfpTrigger(OPEN_EVENT);
                },

            /**
             * Closes the popup
             */
            close: function ()
                {
                    if (!mfp.isOpen) return;

                    mfp.isOpen = false;
                    // for CSS3 animation
                    if (mfp.st.removalDelay)
                        {
                            mfp._addClassToMFP(REMOVING_CLASS);
                            setTimeout(function ()
                            {
                                mfp._close();
                            }, mfp.st.removalDelay);
                        } else

                        mfp._close();

                },

            /**
             * Helper for close() function
             */
            _close: function ()
                {
                    _mfpTrigger(CLOSE_EVENT);

                    var classesToRemove = REMOVING_CLASS + ' ' + READY_CLASS + ' ';

                    mfp.bgOverlay.detach();
                    mfp.wrap.detach();
                    mfp.container.empty();

                    if (mfp.st.mainClass)

                        classesToRemove += mfp.st.mainClass + ' ';

                    mfp._removeClassFromMFP(classesToRemove);

                    if (mfp.fixedContentPos)
                        {
                            var bodyStyles = {paddingRight: 0};

                            bodyStyles.overflow = 'visible';

                            _body.css(bodyStyles);
                        }

                    _document.off('keyup' + EVENT_NS + ' focusin' + EVENT_NS);
                    mfp.ev.off(EVENT_NS);

                    // clean up DOM elements that aren't removed
                    mfp.wrap.attr('class', 'mfp-wrap').removeAttr('style');
                    mfp.bgOverlay.attr('class', 'mfp-bg');
                    mfp.container.attr('class', 'mfp-container');

                    // remove close button from target element
                    if (!mfp.st.closeBtnInside || mfp.currTemplate[mfp.currItem.type] === true)

                        if (mfp.currTemplate.closeBtn)
                            mfp.currTemplate.closeBtn.detach();

                    if (mfp._lastFocusedEl)

                        $(mfp._lastFocusedEl).focus(); // put tab focus back

                    mfp.currTemplate = null;
                    mfp.prevHeight = 0;
                },

            updateSize: function (winHeight)
                {

                    if (mfp.isIOS)
                        {
                            // fixes iOS nav bars https://github.com/dimsemenov/Magnific-Popup/issues/2
                            var zoomLevel = document.documentElement.clientWidth / window.innerWidth;
                            var height = window.innerHeight * zoomLevel;
                            mfp.wrap.css('height', height);
                            mfp.wH = height;
                        } else

                        mfp.wH = winHeight || _window.height();

                    _mfpTrigger('Resize');

                },

            /**
             * Set content of popup based on current index
             */
            updateItemHTML: function ()
                {
                    var item = mfp.items[mfp.index];

                    // Detach and perform modifications
                    mfp.contentContainer.detach();

                    if (!item.parsed)

                        item = mfp.parseEl(mfp.index);

                    mfp.currItem = item;

                    var type = item.type;
                    if (!mfp.currTemplate[type])
                        {
                            var markup = mfp.st[type] ? mfp.st[type].markup : false;
                            if (markup)
                                {
                                    _mfpTrigger('FirstMarkupParse', markup);
                                    mfp.currTemplate[type] = $(markup);
                                } else

                            // if there is no markup found we just define that template is parsed
                                mfp.currTemplate[type] = true;

                        }

                    if (_prevContentType && _prevContentType !== item.type)

                        mfp.container.removeClass('mfp-' + _prevContentType + '-holder');

                    var newContent = mfp['get' + type.charAt(0).toUpperCase() + type.slice(1)](item, mfp.currTemplate[type]);
                    mfp.appendContent(newContent, type);

                    item.preloaded = true;

                    _mfpTrigger(CHANGE_EVENT, item);
                    _prevContentType = item.type;

                    // Append container back after its content changed
                    mfp.container.prepend(mfp.contentContainer);
                },

            /**
             * Set HTML content of popup
             */
            appendContent: function (newContent, type)
                {
                    mfp.content = newContent;

                    if (newContent)
                        {
                            if (mfp.st.closeBtnInside && mfp.currTemplate[type] === true)
                                {
                                    // if there is no markup, we just append close button element inside
                                    if (!mfp.content.find('.mfp-close').length)

                                        mfp.content.append(_getCloseBtn());

                                } else

                                mfp.content = newContent;

                        } else

                        mfp.content = '';

                    _mfpTrigger(BEFORE_APPEND_EVENT);
                    mfp.container.addClass('mfp-' + type + '-holder');

                    mfp.contentContainer.html(mfp.content);
                },

            /**
             * Creates Magnific Popup data object based on given data
             * @param  {int} index Index of item to parse
             */
            parseEl: function (index)
                {
                    var item = mfp.items[index], type = item.type;

                    if (item.tagName)

                        item = { el: $(item) }; else

                        item = { data: item, src: item.src };

                    if (item.el)
                        {
                            var types = mfp.types;

                            // check for 'mfp-TYPE' class
                            for (var i = 0; i < types.length; i++)
                                {
                                    if (item.el.hasClass('mfp-' + types[i]))
                                        {
                                            type = types[i];
                                            break;
                                        }
                                }

                            item.src = item.el.attr('data-mfp-src');
                            if (!item.src)

                                item.src = item.el.attr('href');

                        }

                    item.type = type || mfp.st.type;
                    item.index = index;
                    item.parsed = true;
                    mfp.items[index] = item;
                    _mfpTrigger('ElementParse', item);

                    return mfp.items[index];
                },

            /**
             * Initializes single popup or a group of popups
             */
            addGroup: function (el, options)
                {
                    var eHandler = function (e)
                        {

                            var midClick = options.midClick !== undefined ? options.midClick : $.magnificPopup.defaults.midClick;
                            if (midClick || e.which !== 2)
                                {
                                    var disableOn = options.disableOn !== undefined ? options.disableOn : $.magnificPopup.defaults.disableOn;

                                    if (disableOn)
                                        {
                                            if ($.isFunction(disableOn))
                                                {
                                                    if (!disableOn.call(mfp))

                                                        return true;

                                                } else
                                                { // else it's number
                                                    if ($(window).width() < disableOn)

                                                        return true;

                                                }
                                        }

                                    e.preventDefault();
                                    options.el = $(this);
                                    if (options.delegate)

                                        options.items = el.find(options.delegate);

                                    mfp.open(options);
                                }

                        };

                    if (!options)

                        options = {};

                    var eName = 'click.magnificPopup';
                    if (options.items)
                        {
                            options.isObj = true;
                            el.off(eName).on(eName, eHandler);
                        } else
                        {
                            options.isObj = false;
                            if (options.delegate)
                                {
                                    el.off(eName).on(eName, options.delegate, eHandler);
                                } else
                                {
                                    options.items = el;
                                    el.off(eName).on(eName, eHandler);
                                }
                        }
                },

            /**
             * Updates text on preloader
             */
            updateStatus: function (status, text)
                {

                    if (mfp.preloader)
                        {
                            if (_prevStatus !== status)

                                mfp.container.removeClass('mfp-s-' + _prevStatus);

                            if (!text && status === 'loading')

                                text = mfp.st.tLoading;

                            var data = {
                                status: status,
                                text: text
                            };
                            // allows to modify status
                            _mfpTrigger('UpdateStatus', data);

                            status = data.status;
                            text = data.text;

                            mfp.preloader.html(text);

                            mfp.preloader.find('a').click(function (e)
                            {
                                e.stopImmediatePropagation();
                            });

                            mfp.container.addClass('mfp-s-' + status);
                            _prevStatus = status;
                        }
                },

            /*
             "Private" helpers that aren't private at all
             */
            _addClassToMFP: function (cName)
                {
                    mfp.bgOverlay.addClass(cName);
                    mfp.wrap.addClass(cName);
                },
            _removeClassFromMFP: function (cName)
                {
                    this.bgOverlay.removeClass(cName);
                    mfp.wrap.removeClass(cName);
                },

            _parseMarkup: function (template, values, item)
                {
                    var arr;
                    if (item.data)

                        values = $.extend(item.data, values);

                    _mfpTrigger(MARKUP_PARSE_EVENT, [template, values, item]);

                    $.each(values, function (key, value)
                    {
                        if (value === undefined || value === false)

                            return true;

                        arr = key.split('_');
                        if (arr.length > 1)
                            {
                                var el = template.find(EVENT_NS + '-' + arr[0]);

                                if (el.length > 0)
                                    {
                                        var attr = arr[1];
                                        if (attr === 'replaceWith')
                                            {
                                                if (el[0] !== value[0])

                                                    el.replaceWith(value);

                                            } else if (attr === 'img')
                                            {
                                                if (el.is('img'))

                                                    el.attr('src', value); else

                                                    el.replaceWith('<img src="' + value + '" class="' + el.attr('class') + '" />');

                                            } else

                                            el.attr(arr[1], value);

                                    }

                            } else

                            template.find(EVENT_NS + '-' + key).html(value);

                    });
                }

        };
        /* MagnificPopup core prototype end */

        /**
         * Public static functions
         */
        $.magnificPopup = {
            instance: null,
            proto: MagnificPopup.prototype,
            modules: [],

            open: function (options, index)
                {
                    if (!$.magnificPopup.instance)
                        {
                            mfp = new MagnificPopup();
                            mfp.init();
                            $.magnificPopup.instance = mfp;
                        }

                    if (!options)

                        options = {};

                    options.isObj = true;
                    options.index = index === undefined ? 0 : index;
                    return this.instance.open(options);
                },

            close: function ()
                {
                    return $.magnificPopup.instance.close();
                },

            registerModule: function (name, module)
                {
                    if (module.options)

                        $.magnificPopup.defaults[name] = module.options;

                    $.extend(this.proto, module.proto);
                    this.modules.push(name);
                },

            defaults: {

                // Info about options is docs:
                // http://dimsemenov.com/plugins/magnific-popup/documentation.html#options

                disableOn: 0,

                key: null,

                midClick: false,

                mainClass: 'modal',

                preloader: true,

                focus: '', // CSS selector of input to focus after popup is opened

                closeOnContentClick: false,

                closeBtnInside: true,

                alignTop: false,

                removalDelay: 200,

                fixedContentPos: 'auto',

                fixedBgPos: 'auto',

                overflowY: 'auto',

                closeMarkup: '<button title="%title%" type="button" class="mfp-close">&times;</button>',

                tClose: 'Close (Esc)',

                tLoading: ''

            }
        };

        $.fn.magnificPopup = function (options)
            {
                // Initialize Magnific Popup only when called at least once
                if (!$.magnificPopup.instance)
                    {
                        mfp = new MagnificPopup();
                        mfp.init();
                        $.magnificPopup.instance = mfp;
                    }

                mfp.addGroup($(this), options);
                return $(this);
            };

        /*>>core*/

        /*>>ajax*/
        var AJAX_NS = 'ajax', _ajaxCur, _removeAjaxCursor = function ()
            {
                if (_ajaxCur)

                    _body.removeClass(_ajaxCur);

            };

        $.magnificPopup.registerModule(AJAX_NS, {

            options: {
                settings: null,
                options: {dataType: 'html'},
                cursor: 'mfp-ajax-cur',
                tError: '<a href="%url%">The content</a> could not be loaded.'
            },

            proto: {
                initAjax: function ()
                    {
                        mfp.types.push(AJAX_NS);
                        _ajaxCur = mfp.st.ajax.cursor;

                        _mfpOn(CLOSE_EVENT + '.' + AJAX_NS, function ()
                        {
                            _removeAjaxCursor();
                            if (mfp.req)
                                mfp.req.abort();
                        });
                    },

                getAjax: function (item)
                    {

                        if (_ajaxCur)
                            _body.addClass(_ajaxCur);

                        mfp.updateStatus('loading');

                        var opts = $.extend({
                            url: item.src,
                            success: function (data, textStatus, jqXHR)
                                {

                                    _mfpTrigger('ParseAjax', jqXHR);

                                    mfp.appendContent($(jqXHR.responseText), AJAX_NS);

                                    item.finished = true;

                                    _removeAjaxCursor();

                                    _setFocus();

                                    setTimeout(function ()
                                    {
                                        mfp.wrap.addClass(READY_CLASS);
                                    }, 16);

                                    mfp.updateStatus('ready');

                                },
                            error: function ()
                                {
                                    _removeAjaxCursor();
                                    item.finished = item.loadError = true;
                                    mfp.updateStatus('error', mfp.st.ajax.tError.replace('%url%', item.src));
                                }
                        }, mfp.st.ajax.settings);

                        mfp.req = $.ajax(opts);

                        return '';
                    }
            }
        });

        /*>>ajax*/

        /*>>image*/
        var _imgInterval, _getTitle = function (item)
            {
                if (item.data && item.data.title !== undefined)
                    return item.data.title;

                var src = mfp.st.image.titleSrc;

                if (src)
                    {
                        if ($.isFunction(src))

                            return src.call(mfp, item); else if (item.el)

                            return item.el.attr(src) || '';

                    }
                return '';
            };

        $.magnificPopup.registerModule('image', {

            options: {
                markup: '<div class="mfp-figure">' + '<div class="mfp-close"></div>' + '<div class="mfp-img"></div>' + '<div class="mfp-bottom-bar">' + '<div class="mfp-title"></div>' + '<div class="mfp-counter"></div>' + '</div>' + '</div>',
                cursor: 'mfp-zoom-out-cur',
                titleSrc: 'title',
                verticalFit: true,
                tError: '<a href="%url%">The image</a> could not be loaded.'
            },

            proto: {
                initImage: function ()
                    {
                        var imgSt = mfp.st.image, ns = '.image';

                        mfp.types.push('image');

                        _mfpOn(OPEN_EVENT + ns, function ()
                        {
                            if (mfp.currItem.type === 'image' && imgSt.cursor)

                                _body.addClass(imgSt.cursor);

                        });

                        _mfpOn(CLOSE_EVENT + ns, function ()
                        {
                            if (imgSt.cursor)

                                _body.removeClass(imgSt.cursor);

                            _window.off('resize' + EVENT_NS);
                        });

                        _mfpOn('Resize' + ns, function ()
                        {
                            mfp.resizeImage();
                        });
                    },
                resizeImage: function ()
                    {
                        var item = mfp.currItem;
                        if (!item.img) return;
                        if (mfp.st.image.verticalFit)

                            item.img.css('max-height', mfp.wH + 'px');

                    },
                _onImageHasSize: function (item)
                    {
                        if (item.img)
                            {

                                item.hasSize = true;

                                if (_imgInterval)

                                    clearInterval(_imgInterval);

                                item.isCheckingImgSize = false;

                                _mfpTrigger('ImageHasSize', item);

                                if (item.imgHidden)

                                    mfp.content.removeClass('mfp-loading');
                                item.imgHidden = false;

                            }
                    },

                /**
                 * Function that loops until the image has size to display elements that rely on it asap
                 */
                findImageSize: function (item)
                    {

                        var counter = 0, img = item.img[0], mfpSetInterval = function (delay)
                            {

                                if (_imgInterval)

                                    clearInterval(_imgInterval);

                                // decelerating interval that checks for size of an image
                                _imgInterval = setInterval(function ()
                                {
                                    if (img.naturalWidth > 0)
                                        {
                                            mfp._onImageHasSize(item);
                                            return;
                                        }

                                    if (counter > 200)

                                        clearInterval(_imgInterval);

                                    counter++;
                                    if (counter === 3)

                                        mfpSetInterval(10); else if (counter === 40)

                                        mfpSetInterval(50); else if (counter === 100)

                                        mfpSetInterval(500);

                                }, delay);
                            };

                        mfpSetInterval(1);
                    },

                getImage: function (item, template)
                    {

                        var guard = 0,

                        // image load complete handler
                            onLoadComplete = function ()
                                {
                                    if (item)
                                        {
                                            if (item.img[0].complete)
                                                {
                                                    item.img.off('.mfploader');

                                                    if (item === mfp.currItem)
                                                        {
                                                            mfp._onImageHasSize(item);

                                                            mfp.updateStatus('ready');
                                                        }

                                                    item.hasSize = true;
                                                    item.loaded = true;

                                                } else
                                                {
                                                    // if image complete check fails 200 times (20 sec), we assume that there was an error.
                                                    guard++;
                                                    if (guard < 200)

                                                        setTimeout(onLoadComplete, 100); else

                                                        onLoadError();

                                                }
                                        }
                                },

                        // image error handler
                            onLoadError = function ()
                                {
                                    if (item)
                                        {
                                            item.img.off('.mfploader');
                                            if (item === mfp.currItem)
                                                {
                                                    mfp._onImageHasSize(item);
                                                    mfp.updateStatus('error', imgSt.tError.replace('%url%', item.src));
                                                }

                                            item.hasSize = true;
                                            item.loaded = true;
                                            item.loadError = true;
                                        }
                                }, imgSt = mfp.st.image;

                        var el = template.find('.mfp-img');
                        if (el.length)
                            {
                                var img = new Image();
                                img.className = 'mfp-img';
                                item.img = $(img).on('load.mfploader', onLoadComplete).on('error.mfploader', onLoadError);
                                img.src = item.src;

                                // without clone() "error" event is not firing when IMG is replaced by new IMG
                                if (el.is('img'))

                                    item.img = item.img.clone();

                            }

                        mfp._parseMarkup(template, {
                            title: _getTitle(item),
                            img_replaceWith: item.img
                        }, item);

                        mfp.resizeImage();

                        if (item.hasSize)
                            {
                                if (_imgInterval) clearInterval(_imgInterval);

                                if (item.loadError)
                                    {
                                        template.addClass('mfp-loading');
                                        mfp.updateStatus('error', imgSt.tError.replace('%url%', item.src));
                                    } else
                                    {
                                        template.removeClass('mfp-loading');
                                        mfp.updateStatus('ready');
                                    }
                                return template;
                            }

                        mfp.updateStatus('loading');
                        item.loading = true;

                        if (!item.hasSize)
                            {
                                item.imgHidden = true;
                                template.addClass('mfp-loading');
                                mfp.findImageSize(item);
                            }

                        return template;
                    }
            }
        });

        /*>>image*/

        /*>>iframe*/

        var IFRAME_NS = 'iframe';

        $.magnificPopup.registerModule(IFRAME_NS, {

            options: {
                markup: '<div class="mfp-iframe-scaler">' + '<div class="mfp-close"></div>' + '<iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe>' + '</div>',

                srcAction: 'iframe_src',

                // we don't care and support only one default type of URL by default
                patterns: {
                    youtube: {
                        index: 'youtube.com',
                        id: 'v=',
                        src: '//www.youtube.com/embed/%id%?autoplay=1'
                    },
                    vimeo: {
                        index: 'vimeo.com/',
                        id: '/',
                        src: '//player.vimeo.com/video/%id%?autoplay=1'
                    },
                    gmaps: {
                        index: '//maps.google.',
                        src: '%id%&output=embed'
                    }
                }
            },

            proto: {
                initIframe: function ()
                    {
                        mfp.types.push(IFRAME_NS);

                    },

                getIframe: function (item, template)
                    {
                        var embedSrc = item.src;
                        var iframeSt = mfp.st.iframe;

                        $.each(iframeSt.patterns, function ()
                        {
                            if (embedSrc.indexOf(this.index) > -1)
                                {
                                    if (this.id)
                                        {
                                            if (typeof this.id === 'string')

                                                embedSrc = embedSrc.substr(embedSrc.lastIndexOf(this.id) + this.id.length, embedSrc.length); else

                                                embedSrc = this.id.call(this, embedSrc);

                                        }
                                    embedSrc = this.src.replace('%id%', embedSrc);
                                    return false; // break;
                                }
                        });

                        var dataObj = {};
                        if (iframeSt.srcAction)

                            dataObj[iframeSt.srcAction] = embedSrc;

                        mfp._parseMarkup(template, dataObj, item);

                        mfp.updateStatus('ready');

                        return template;
                    }
            }
        });

        /*>>iframe*/

        /*>>inline*/

        var INLINE_NS = 'inline',
            _hasPlaceholder;

        $.magnificPopup.registerModule(INLINE_NS, {
            options: {
                hiddenClass: NS+'-hide',
                markup: '',
                tNotFound: 'Content not found'
            },
            proto: {

                initInline: function() {
                    mfp.types.push(INLINE_NS);
                    _hasPlaceholder = false;

                    _mfpOn(CLOSE_EVENT+'.'+INLINE_NS, function() {
                        var item = mfp.currItem;
                        if(item.type === INLINE_NS) {
                            if(_hasPlaceholder) {
                                for(var i = 0; i < mfp.items.length; i++) {
                                    item = mfp.items[i];
                                    if(item && item.inlinePlaceholder){
                                        item.inlinePlaceholder.after( item.inlineElement.addClass(mfp.st.inline.hiddenClass) ).detach();
                                    }
                                }
                            }
                            item.inlinePlaceholder = item.inlineElement = null;
                        }
                    });
                },

                getInline: function(item, template) {
                    mfp.updateStatus('ready');

                    if(item.src) {
                        var inlineSt = mfp.st.inline;
                        // items.src can be String-CSS-selector or jQuery element
                        if(typeof item.src !== 'string') {
                            item.isElement = true;
                        }

                        if(!item.isElement && !item.inlinePlaceholder) {
                            item.inlinePlaceholder = _getEl(inlineSt.hiddenClass);
                        }

                        if(item.isElement) {
                            item.inlineElement = item.src;
                        } else if(!item.inlineElement) {
                            item.inlineElement = $(item.src);
                            if(!item.inlineElement.length) {
                                mfp.updateStatus('error', inlineSt.tNotFound);
                                item.inlineElement = $('<div>');
                            }
                        }

                        if(item.inlinePlaceholder) {
                            _hasPlaceholder = true;
                        }



                        item.inlineElement.after(item.inlinePlaceholder).detach().removeClass(inlineSt.hiddenClass);
                        return item.inlineElement;
                    } else {
                        mfp._parseMarkup(template, {}, item);
                        return template;
                    }
                }
            }
        });

        /*>>inline*/

    })(window.jQuery || window.Zepto);