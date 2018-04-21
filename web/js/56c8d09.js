/*
 * jQuery Cycle Plugin (with Transition Definitions)
 * Examples and documentation at: http://jquery.malsup.com/cycle/
 * Copyright (c) 2007-2010 M. Alsup
 * Version: 2.99 (12-MAR-2011)
 * Dual licensed under the MIT and GPL licenses.
 * http://jquery.malsup.com/license.html
 * Requires: jQuery v1.3.2 or later
 */
(function($) {
    var ver = "2.99";
    if ($.support == undefined) {
        $.support = {
            opacity: !($.browser.msie)
        };
    }

    function debug(s) {
        $.fn.cycle.debug && log(s);
    }

    function log() {
        window.console && console.log && console.log("[cycle] " + Array.prototype.join.call(arguments, " "));
    }
    $.expr[":"].paused = function(el) {
        return el.cyclePause;
    };
    $.fn.cycle = function(options, arg2) {
        var o = {
            s: this.selector,
            c: this.context
        };
        if (this.length === 0 && options != "stop") {
            if (!$.isReady && o.s) {
                log("DOM not ready, queuing slideshow");
                $(function() {
                    $(o.s, o.c).cycle(options, arg2);
                });
                return this;
            }
            log("terminating; zero elements found by selector" + ($.isReady ? "" : " (DOM not ready)"));
            return this;
        }
        return this.each(function() {
            var opts = handleArguments(this, options, arg2);
            if (opts === false) {
                return;
            }
            opts.updateActivePagerLink = opts.updateActivePagerLink || $.fn.cycle.updateActivePagerLink;
            if (this.cycleTimeout) {
                clearTimeout(this.cycleTimeout);
            }
            this.cycleTimeout = this.cyclePause = 0;
            var $cont = $(this);
            var $slides = opts.slideExpr ? $(opts.slideExpr, this) : $cont.children();
            var els = $slides.get();
            if (els.length < 2) {
                log("terminating; too few slides: " + els.length);
                $slides.addClass('current-slide');
                return;
            }
            var opts2 = buildOptions($cont, $slides, els, opts, o);
            if (opts2 === false) {
                return;
            }
            var startTime = opts2.continuous ? 10 : getTimeout(els[opts2.currSlide], els[opts2.nextSlide], opts2, !opts2.backwards);
            if (startTime) {
                startTime += (opts2.delay || 0);
                if (startTime < 10) {
                    startTime = 10;
                }
                debug("first timeout: " + startTime);
                this.cycleTimeout = setTimeout(function() {
                    go(els, opts2, 0, !opts.backwards);
                }, startTime);
            }
        });
    };

    function handleArguments(cont, options, arg2) {
        if (cont.cycleStop == undefined) {
            cont.cycleStop = 0;
        }
        if (options === undefined || options === null) {
            options = {};
        }
        if (options.constructor == String) {
            switch (options) {
                case "destroy":
                case "stop":
                    var opts = $(cont).data("cycle.opts");
                    if (!opts) {
                        return false;
                    }
                    cont.cycleStop++;
                    if (cont.cycleTimeout) {
                        clearTimeout(cont.cycleTimeout);
                    }
                    cont.cycleTimeout = 0;
                    $(cont).removeData("cycle.opts");
                    if (options == "destroy") {
                        destroy(opts);
                    }
                    return false;
                case "toggle":
                    cont.cyclePause = (cont.cyclePause === 1) ? 0 : 1;
                    checkInstantResume(cont.cyclePause, arg2, cont);
                    return false;
                case "pause":
                    cont.cyclePause = 1;
                    return false;
                case "resume":
                    cont.cyclePause = 0;
                    checkInstantResume(false, arg2, cont);
                    return false;
                case "prev":
                case "next":
                    var opts = $(cont).data("cycle.opts");
                    if (!opts) {
                        log('options not found, "prev/next" ignored');
                        return false;
                    }
                    $.fn.cycle[options](opts);
                    return false;
                default:
                    options = {
                        fx: options
                    };
            }
            return options;
        } else {
            if (options.constructor == Number) {
                var num = options;
                options = $(cont).data("cycle.opts");
                if (!options) {
                    log("options not found, can not advance slide");
                    return false;
                }
                if (num < 0 || num >= options.elements.length) {
                    log("invalid slide index: " + num);
                    return false;
                }
                options.nextSlide = num;
                if (cont.cycleTimeout) {
                    clearTimeout(cont.cycleTimeout);
                    cont.cycleTimeout = 0;
                }
                if (typeof arg2 == "string") {
                    options.oneTimeFx = arg2;
                }
                go(options.elements, options, 1, num >= options.currSlide);
                return false;
            }
        }
        return options;

        function checkInstantResume(isPaused, arg2, cont) {
            if (!isPaused && arg2 === true) {
                var options = $(cont).data("cycle.opts");
                if (!options) {
                    log("options not found, can not resume");
                    return false;
                }
                if (cont.cycleTimeout) {
                    clearTimeout(cont.cycleTimeout);
                    cont.cycleTimeout = 0;
                }
                go(options.elements, options, 1, !options.backwards);
            }
        }
    }

    function removeFilter(el, opts) {
        if (!$.support.opacity && opts.cleartype && el.style.filter) {
            try {
                el.style.removeAttribute("filter");
            } catch (smother) {}
        }
    }

    function destroy(opts) {
        if (opts.next) {
            $(opts.next).unbind(opts.prevNextEvent);
        }
        if (opts.prev) {
            $(opts.prev).unbind(opts.prevNextEvent);
        }
        if (opts.pager || opts.pagerAnchorBuilder) {
            $.each(opts.pagerAnchors || [], function() {
                this.unbind().remove();
            });
        }
        opts.pagerAnchors = null;
        if (opts.destroy) {
            opts.destroy(opts);
        }
    }

    function buildOptions($cont, $slides, els, options, o) {
        var opts = $.extend({}, $.fn.cycle.defaults, options || {}, $.metadata ? $cont.metadata() : $.meta ? $cont.data() : {});
        if (opts.autostop) {
            opts.countdown = opts.autostopCount || els.length;
        }
        var cont = $cont[0];
        $cont.data("cycle.opts", opts);
        opts.$cont = $cont;
        opts.stopCount = cont.cycleStop;
        opts.elements = els;
        opts.before = opts.before ? [opts.before] : [];
        opts.after = opts.after ? [opts.after] : [];
        if (!$.support.opacity && opts.cleartype) {
            opts.after.push(function() {
                removeFilter(this, opts);
            });
        }
        if (opts.continuous) {
            opts.after.push(function() {
                go(els, opts, 0, !opts.backwards);
            });
        }
        saveOriginalOpts(opts);
        if (!$.support.opacity && opts.cleartype && !opts.cleartypeNoBg) {
            clearTypeFix($slides);
        }
        if ($cont.css("position") == "static") {
            $cont.css("position", "relative");
        }
        if (opts.width) {
            $cont.width(opts.width);
        }
        if (opts.height && opts.height != "auto") {
            $cont.height(opts.height);
        }
        if (opts.startingSlide) {
            opts.startingSlide = parseInt(opts.startingSlide);
        } else {
            if (opts.backwards) {
                opts.startingSlide = els.length - 1;
            }
        }
        if (opts.random) {
            opts.randomMap = [];
            for (var i = 0; i < els.length; i++) {
                opts.randomMap.push(i);
            }
            opts.randomMap.sort(function(a, b) {
                return Math.random() - 0.5;
            });
            opts.randomIndex = 1;
            opts.startingSlide = opts.randomMap[1];
        } else {
            if (opts.startingSlide >= els.length) {
                opts.startingSlide = 0;
            }
        }
        opts.currSlide = opts.startingSlide || 0;
        var first = opts.startingSlide;
        $slides.css({
            position: "absolute",
            top: 0,
            left: 0
        }).hide().each(function(i) {
            var z;
            if (opts.backwards) {
                z = first ? i <= first ? els.length + (i - first) : first - i : els.length - i;
            } else {
                z = first ? i >= first ? els.length - (i - first) : first - i : els.length - i;
            }
            $(this).css("z-index", z);
        });
        $(els[first]).css("opacity", 1).show();
        removeFilter(els[first], opts);
        if (opts.fit && opts.width) {
            $slides.width(opts.width);
        }
        if (opts.fit && opts.height && opts.height != "auto") {
            $slides.height(opts.height);
        }
        var reshape = opts.containerResize && !$cont.innerHeight();
        if (reshape) {
            var maxw = 0,
                maxh = 0;
            for (var j = 0; j < els.length; j++) {
                var $e = $(els[j]),
                    e = $e[0],
                    w = $e.outerWidth(),
                    h = $e.outerHeight();
                if (!w) {
                    w = e.offsetWidth || e.width || $e.attr("width");
                }
                if (!h) {
                    h = e.offsetHeight || e.height || $e.attr("height");
                }
                maxw = w > maxw ? w : maxw;
                maxh = h > maxh ? h : maxh;
            }
            if (maxw > 0 && maxh > 0) {
                $cont.css({
                    width: maxw + "px",
                    height: maxh + "px"
                });
            }
        }
        if (opts.pause) {
            $cont.hover(function() {
                this.cyclePause++;
            }, function() {
                this.cyclePause--;
            });
        }
        if (supportMultiTransitions(opts) === false) {
            return false;
        }
        var requeue = false;
        options.requeueAttempts = options.requeueAttempts || 0;
        $slides.each(function() {
            var $el = $(this);
            this.cycleH = (opts.fit && opts.height) ? opts.height : ($el.height() || this.offsetHeight || this.height || $el.attr("height") || 0);
            this.cycleW = (opts.fit && opts.width) ? opts.width : ($el.width() || this.offsetWidth || this.width || $el.attr("width") || 0);
            if ($el.is("img")) {
                var loadingIE = ($.browser.msie && this.cycleW == 28 && this.cycleH == 30 && !this.complete);
                var loadingFF = ($.browser.mozilla && this.cycleW == 34 && this.cycleH == 19 && !this.complete);
                var loadingOp = ($.browser.opera && ((this.cycleW == 42 && this.cycleH == 19) || (this.cycleW == 37 && this.cycleH == 17)) && !this.complete);
                var loadingOther = (this.cycleH == 0 && this.cycleW == 0 && !this.complete);
                if (loadingIE || loadingFF || loadingOp || loadingOther) {
                    if (o.s && opts.requeueOnImageNotLoaded && ++options.requeueAttempts < 100) {
                        log(options.requeueAttempts, " - img slide not loaded, requeuing slideshow: ", this.src, this.cycleW, this.cycleH);
                        setTimeout(function() {
                            $(o.s, o.c).cycle(options);
                        }, opts.requeueTimeout);
                        requeue = true;
                        return false;
                    } else {
                        log("could not determine size of image: " + this.src, this.cycleW, this.cycleH);
                    }
                }
            }
            return true;
        });
        if (requeue) {
            return false;
        }
        opts.cssBefore = opts.cssBefore || {};
        opts.cssAfter = opts.cssAfter || {};
        opts.cssFirst = opts.cssFirst || {};
        opts.animIn = opts.animIn || {};
        opts.animOut = opts.animOut || {};
        $slides.not(":eq(" + first + ")").css(opts.cssBefore);
        $($slides[first]).css(opts.cssFirst);
        if (opts.timeout) {
            opts.timeout = parseInt(opts.timeout);
            if (opts.speed.constructor == String) {
                opts.speed = $.fx.speeds[opts.speed] || parseInt(opts.speed);
            }
            if (!opts.sync) {
                opts.speed = opts.speed / 2;
            }
            var buffer = opts.fx == "none" ? 0 : opts.fx == "shuffle" ? 500 : 250;
            while ((opts.timeout - opts.speed) < buffer) {
                opts.timeout += opts.speed;
            }
        }
        if (opts.easing) {
            opts.easeIn = opts.easeOut = opts.easing;
        }
        if (!opts.speedIn) {
            opts.speedIn = opts.speed;
        }
        if (!opts.speedOut) {
            opts.speedOut = opts.speed;
        }
        opts.slideCount = els.length;
        opts.currSlide = opts.lastSlide = first;
        if (opts.random) {
            if (++opts.randomIndex == els.length) {
                opts.randomIndex = 0;
            }
            opts.nextSlide = opts.randomMap[opts.randomIndex];
        } else {
            if (opts.backwards) {
                opts.nextSlide = opts.startingSlide == 0 ? (els.length - 1) : opts.startingSlide - 1;
            } else {
                opts.nextSlide = opts.startingSlide >= (els.length - 1) ? 0 : opts.startingSlide + 1;
            }
        }
        if (!opts.multiFx) {
            var init = $.fn.cycle.transitions[opts.fx];
            if ($.isFunction(init)) {
                init($cont, $slides, opts);
            } else {
                if (opts.fx != "custom" && !opts.multiFx) {
                    log("unknown transition: " + opts.fx, "; slideshow terminating");
                    return false;
                }
            }
        }
        var e0 = $slides[first];
        if (opts.before.length) {
            opts.before[0].apply(e0, [e0, e0, opts, true]);
        }
        if (opts.after.length) {
            opts.after[0].apply(e0, [e0, e0, opts, true]);
        }
        if (opts.next) {
            $(opts.next).bind(opts.prevNextEvent, function() {
                return advance(opts, 1);
            });
        }
        if (opts.prev) {
            $(opts.prev).bind(opts.prevNextEvent, function() {
                return advance(opts, 0);
            });
        }
        if (opts.pager || opts.pagerAnchorBuilder) {
            buildPager(els, opts);
        }
        exposeAddSlide(opts, els);
        return opts;
    }

    function saveOriginalOpts(opts) {
        opts.original = {
            before: [],
            after: []
        };
        opts.original.cssBefore = $.extend({}, opts.cssBefore);
        opts.original.cssAfter = $.extend({}, opts.cssAfter);
        opts.original.animIn = $.extend({}, opts.animIn);
        opts.original.animOut = $.extend({}, opts.animOut);
        $.each(opts.before, function() {
            opts.original.before.push(this);
        });
        $.each(opts.after, function() {
            opts.original.after.push(this);
        });
    }

    function supportMultiTransitions(opts) {
        var i, tx, txs = $.fn.cycle.transitions;
        if (opts.fx.indexOf(",") > 0) {
            opts.multiFx = true;
            opts.fxs = opts.fx.replace(/\s*/g, "").split(",");
            for (i = 0; i < opts.fxs.length; i++) {
                var fx = opts.fxs[i];
                tx = txs[fx];
                if (!tx || !txs.hasOwnProperty(fx) || !$.isFunction(tx)) {
                    log("discarding unknown transition: ", fx);
                    opts.fxs.splice(i, 1);
                    i--;
                }
            }
            if (!opts.fxs.length) {
                log("No valid transitions named; slideshow terminating.");
                return false;
            }
        } else {
            if (opts.fx == "all") {
                opts.multiFx = true;
                opts.fxs = [];
                for (p in txs) {
                    tx = txs[p];
                    if (txs.hasOwnProperty(p) && $.isFunction(tx)) {
                        opts.fxs.push(p);
                    }
                }
            }
        }
        if (opts.multiFx && opts.randomizeEffects) {
            var r1 = Math.floor(Math.random() * 20) + 30;
            for (i = 0; i < r1; i++) {
                var r2 = Math.floor(Math.random() * opts.fxs.length);
                opts.fxs.push(opts.fxs.splice(r2, 1)[0]);
            }
            debug("randomized fx sequence: ", opts.fxs);
        }
        return true;
    }

    function exposeAddSlide(opts, els) {
        opts.addSlide = function(newSlide, prepend) {
            var $s = $(newSlide),
                s = $s[0];
            if (!opts.autostopCount) {
                opts.countdown++;
            }
            els[prepend ? "unshift" : "push"](s);
            if (opts.els) {
                opts.els[prepend ? "unshift" : "push"](s);
            }
            opts.slideCount = els.length;
            $s.css("position", "absolute");
            $s[prepend ? "prependTo" : "appendTo"](opts.$cont);
            if (prepend) {
                opts.currSlide++;
                opts.nextSlide++;
            }
            if (!$.support.opacity && opts.cleartype && !opts.cleartypeNoBg) {
                clearTypeFix($s);
            }
            if (opts.fit && opts.width) {
                $s.width(opts.width);
            }
            if (opts.fit && opts.height && opts.height != "auto") {
                $s.height(opts.height);
            }
            s.cycleH = (opts.fit && opts.height) ? opts.height : $s.height();
            s.cycleW = (opts.fit && opts.width) ? opts.width : $s.width();
            $s.css(opts.cssBefore);
            if (opts.pager || opts.pagerAnchorBuilder) {
                $.fn.cycle.createPagerAnchor(els.length - 1, s, $(opts.pager), els, opts);
            }
            if ($.isFunction(opts.onAddSlide)) {
                opts.onAddSlide($s);
            } else {
                $s.hide();
            }
        };
    }
    $.fn.cycle.resetState = function(opts, fx) {
        fx = fx || opts.fx;
        opts.before = [];
        opts.after = [];
        opts.cssBefore = $.extend({}, opts.original.cssBefore);
        opts.cssAfter = $.extend({}, opts.original.cssAfter);
        opts.animIn = $.extend({}, opts.original.animIn);
        opts.animOut = $.extend({}, opts.original.animOut);
        opts.fxFn = null;
        $.each(opts.original.before, function() {
            opts.before.push(this);
        });
        $.each(opts.original.after, function() {
            opts.after.push(this);
        });
        var init = $.fn.cycle.transitions[fx];
        if ($.isFunction(init)) {
            init(opts.$cont, $(opts.elements), opts);
        }
    };

    function go(els, opts, manual, fwd) {
        if (manual && opts.busy && opts.manualTrump) {
            debug("manualTrump in go(), stopping active transition");
            $(els).stop(true, true);
            opts.busy = 0;
        }
        if (opts.busy) {
            debug("transition active, ignoring new tx request");
            return;
        }
        var p = opts.$cont[0],
            curr = els[opts.currSlide],
            next = els[opts.nextSlide];
        if (p.cycleStop != opts.stopCount || p.cycleTimeout === 0 && !manual) {
            return;
        }
        if (!manual && !p.cyclePause && !opts.bounce && ((opts.autostop && (--opts.countdown <= 0)) || (opts.nowrap && !opts.random && opts.nextSlide < opts.currSlide))) {
            if (opts.end) {
                opts.end(opts);
            }
            return;
        }
        var changed = false;
        if ((manual || !p.cyclePause) && (opts.nextSlide != opts.currSlide)) {
            changed = true;
            var fx = opts.fx;
            curr.cycleH = curr.cycleH || $(curr).height();
            curr.cycleW = curr.cycleW || $(curr).width();
            next.cycleH = next.cycleH || $(next).height();
            next.cycleW = next.cycleW || $(next).width();
            if (opts.multiFx) {
                if (opts.lastFx == undefined || ++opts.lastFx >= opts.fxs.length) {
                    opts.lastFx = 0;
                }
                fx = opts.fxs[opts.lastFx];
                opts.currFx = fx;
            }
            if (opts.oneTimeFx) {
                fx = opts.oneTimeFx;
                opts.oneTimeFx = null;
            }
            $.fn.cycle.resetState(opts, fx);
            if (opts.before.length) {
                $.each(opts.before, function(i, o) {
                    if (p.cycleStop != opts.stopCount) {
                        return;
                    }
                    o.apply(next, [curr, next, opts, fwd]);
                });
            }
            var after = function() {
                opts.busy = 0;
                $.each(opts.after, function(i, o) {
                    if (p.cycleStop != opts.stopCount) {
                        return;
                    }
                    o.apply(next, [curr, next, opts, fwd]);
                });
            };
            debug("tx firing(" + fx + "); currSlide: " + opts.currSlide + "; nextSlide: " + opts.nextSlide);
            opts.busy = 1;
            if (opts.fxFn) {
                opts.fxFn(curr, next, opts, after, fwd, manual && opts.fastOnEvent);
            } else {
                if ($.isFunction($.fn.cycle[opts.fx])) {
                    $.fn.cycle[opts.fx](curr, next, opts, after, fwd, manual && opts.fastOnEvent);
                } else {
                    $.fn.cycle.custom(curr, next, opts, after, fwd, manual && opts.fastOnEvent);
                }
            }
        }
        if (changed || opts.nextSlide == opts.currSlide) {
            opts.lastSlide = opts.currSlide;
            if (opts.random) {
                opts.currSlide = opts.nextSlide;
                if (++opts.randomIndex == els.length) {
                    opts.randomIndex = 0;
                }
                opts.nextSlide = opts.randomMap[opts.randomIndex];
                if (opts.nextSlide == opts.currSlide) {
                    opts.nextSlide = (opts.currSlide == opts.slideCount - 1) ? 0 : opts.currSlide + 1;
                }
            } else {
                if (opts.backwards) {
                    var roll = (opts.nextSlide - 1) < 0;
                    if (roll && opts.bounce) {
                        opts.backwards = !opts.backwards;
                        opts.nextSlide = 1;
                        opts.currSlide = 0;
                    } else {
                        opts.nextSlide = roll ? (els.length - 1) : opts.nextSlide - 1;
                        opts.currSlide = roll ? 0 : opts.nextSlide + 1;
                    }
                } else {
                    var roll = (opts.nextSlide + 1) == els.length;
                    if (roll && opts.bounce) {
                        opts.backwards = !opts.backwards;
                        opts.nextSlide = els.length - 2;
                        opts.currSlide = els.length - 1;
                    } else {
                        opts.nextSlide = roll ? 0 : opts.nextSlide + 1;
                        opts.currSlide = roll ? els.length - 1 : opts.nextSlide - 1;
                    }
                }
            }
        }
        if (changed && opts.pager) {
            opts.updateActivePagerLink(opts.pager, opts.currSlide, opts.activePagerClass);
        }
        var ms = 0;
        if (opts.timeout && !opts.continuous) {
            ms = getTimeout(els[opts.currSlide], els[opts.nextSlide], opts, fwd);
        } else {
            if (opts.continuous && p.cyclePause) {
                ms = 10;
            }
        }
        if (ms > 0) {
            p.cycleTimeout = setTimeout(function() {
                go(els, opts, 0, !opts.backwards);
            }, ms);
        }
    }
    $.fn.cycle.updateActivePagerLink = function(pager, currSlide, clsName) {
        $(pager).each(function() {
            $(this).children().removeClass(clsName).eq(currSlide).addClass(clsName);
        });
    };

    function getTimeout(curr, next, opts, fwd) {
        if (opts.timeoutFn) {
            var t = opts.timeoutFn.call(curr, curr, next, opts, fwd);
            while (opts.fx != "none" && (t - opts.speed) < 250) {
                t += opts.speed;
            }
            debug("calculated timeout: " + t + "; speed: " + opts.speed);
            if (t !== false) {
                return t;
            }
        }
        return opts.timeout;
    }
    $.fn.cycle.next = function(opts) {
        advance(opts, 1);
    };
    $.fn.cycle.prev = function(opts) {
        advance(opts, 0);
    };

    function advance(opts, moveForward) {
        var val = moveForward ? 1 : -1;
        var els = opts.elements;
        var p = opts.$cont[0],
            timeout = p.cycleTimeout;
        if (timeout) {
            clearTimeout(timeout);
            p.cycleTimeout = 0;
        }
        if (opts.random && val < 0) {
            opts.randomIndex--;
            if (--opts.randomIndex == -2) {
                opts.randomIndex = els.length - 2;
            } else {
                if (opts.randomIndex == -1) {
                    opts.randomIndex = els.length - 1;
                }
            }
            opts.nextSlide = opts.randomMap[opts.randomIndex];
        } else {
            if (opts.random) {
                opts.nextSlide = opts.randomMap[opts.randomIndex];
            } else {
                opts.nextSlide = opts.currSlide + val;
                if (opts.nextSlide < 0) {
                    if (opts.nowrap) {
                        return false;
                    }
                    opts.nextSlide = els.length - 1;
                } else {
                    if (opts.nextSlide >= els.length) {
                        if (opts.nowrap) {
                            return false;
                        }
                        opts.nextSlide = 0;
                    }
                }
            }
        }
        var cb = opts.onPrevNextEvent || opts.prevNextClick;
        if ($.isFunction(cb)) {
            cb(val > 0, opts.nextSlide, els[opts.nextSlide]);
        }
        go(els, opts, 1, moveForward);
        return false;
    }

    function buildPager(els, opts) {
        var $p = $(opts.pager);
        $.each(els, function(i, o) {
            $.fn.cycle.createPagerAnchor(i, o, $p, els, opts);
        });
        opts.updateActivePagerLink(opts.pager, opts.startingSlide, opts.activePagerClass);
    }
    $.fn.cycle.createPagerAnchor = function(i, el, $p, els, opts) {
        var a;
        if ($.isFunction(opts.pagerAnchorBuilder)) {
            a = opts.pagerAnchorBuilder(i, el);
            debug("pagerAnchorBuilder(" + i + ", el) returned: " + a);
        } else {
            a = '<a href="#">' + (i + 1) + "</a>";
        }
        if (!a) {
            return;
        }
        var $a = $(a);
        if ($a.parents("body").length === 0) {
            var arr = [];
            if ($p.length > 1) {
                $p.each(function() {
                    var $clone = $a.clone(true);
                    $(this).append($clone);
                    arr.push($clone[0]);
                });
                $a = $(arr);
            } else {
                $a.appendTo($p);
            }
        }
        opts.pagerAnchors = opts.pagerAnchors || [];
        opts.pagerAnchors.push($a);
        $a.bind(opts.pagerEvent, function(e) {
            e.preventDefault();
            opts.nextSlide = i;
            var p = opts.$cont[0],
                timeout = p.cycleTimeout;
            if (timeout) {
                clearTimeout(timeout);
                p.cycleTimeout = 0;
            }
            var cb = opts.onPagerEvent || opts.pagerClick;
            if ($.isFunction(cb)) {
                cb(opts.nextSlide, els[opts.nextSlide]);
            }
            go(els, opts, 1, opts.currSlide < i);
        });
        if (!/^click/.test(opts.pagerEvent) && !opts.allowPagerClickBubble) {
            $a.bind("click.cycle", function() {
                return false;
            });
        }
        if (opts.pauseOnPagerHover) {
            $a.hover(function() {
                opts.$cont[0].cyclePause++;
            }, function() {
                opts.$cont[0].cyclePause--;
            });
        }
    };
    $.fn.cycle.hopsFromLast = function(opts, fwd) {
        var hops, l = opts.lastSlide,
            c = opts.currSlide;
        if (fwd) {
            hops = c > l ? c - l : opts.slideCount - l;
        } else {
            hops = c < l ? l - c : l + opts.slideCount - c;
        }
        return hops;
    };

    function clearTypeFix($slides) {
        debug("applying clearType background-color hack");

        function hex(s) {
            s = parseInt(s).toString(16);
            return s.length < 2 ? "0" + s : s;
        }

        function getBg(e) {
            for (; e && e.nodeName.toLowerCase() != "html"; e = e.parentNode) {
                var v = $.css(e, "background-color");
                if (v && v.indexOf("rgb") >= 0) {
                    var rgb = v.match(/\d+/g);
                    return "#" + hex(rgb[0]) + hex(rgb[1]) + hex(rgb[2]);
                }
                if (v && v != "transparent") {
                    return v;
                }
            }
            return "#ffffff";
        }
        $slides.each(function() {
            $(this).css("background-color", getBg(this));
        });
    }
    $.fn.cycle.commonReset = function(curr, next, opts, w, h, rev) {
        $(opts.elements).not(curr).hide();
        $(curr).removeClass('current-slide');
        $(next).addClass('current-slide');
        if (typeof opts.cssBefore.opacity == "undefined") {
            opts.cssBefore.opacity = 1;
        }
        opts.cssBefore.display = "block";
        if (opts.slideResize && w !== false && next.cycleW > 0) {
            opts.cssBefore.width = next.cycleW;
        }
        if (opts.slideResize && h !== false && next.cycleH > 0) {
            opts.cssBefore.height = next.cycleH;
        }
        opts.cssAfter = opts.cssAfter || {};
        opts.cssAfter.display = "none";
        $(curr).css("zIndex", opts.slideCount + (rev === true ? 1 : 0));
        $(next).css("zIndex", opts.slideCount + (rev === true ? 0 : 1));
    };
    $.fn.cycle.custom = function(curr, next, opts, cb, fwd, speedOverride) {
        var $l = $(curr),
            $n = $(next);
        var speedIn = opts.speedIn,
            speedOut = opts.speedOut,
            easeIn = opts.easeIn,
            easeOut = opts.easeOut;
        $n.css(opts.cssBefore);
        if (speedOverride) {
            if (typeof speedOverride == "number") {
                speedIn = speedOut = speedOverride;
            } else {
                speedIn = speedOut = 1;
            }
            easeIn = easeOut = null;
        }
        var fn = function() {
            $n.animate(opts.animIn, speedIn, easeIn, function() {
                cb();
            });
        };
        $l.animate(opts.animOut, speedOut, easeOut, function() {
            $l.css(opts.cssAfter);
            if (!opts.sync) {
                fn();
            }
        });
        if (opts.sync) {
            fn();
        }
    };
    $.fn.cycle.transitions = {
        fade: function($cont, $slides, opts) {
            $slides.not(":eq(" + opts.currSlide + ")").css("opacity", 0);
            opts.before.push(function(curr, next, opts) {
                $.fn.cycle.commonReset(curr, next, opts);
                opts.cssBefore.opacity = 0;
            });
            opts.animIn = {
                opacity: 1
            };
            opts.animOut = {
                opacity: 0
            };
            opts.cssBefore = {
                top: 0,
                left: 0
            };
        }
    };
    $.fn.cycle.ver = function() {
        return ver;
    };
    $.fn.cycle.defaults = {
        activePagerClass: "activeSlide",
        after: null,
        allowPagerClickBubble: false,
        animIn: null,
        animOut: null,
        autostop: 0,
        autostopCount: 0,
        backwards: false,
        before: null,
        cleartype: !$.support.opacity,
        cleartypeNoBg: false,
        containerResize: 1,
        continuous: 0,
        cssAfter: null,
        cssBefore: null,
        delay: 0,
        easeIn: null,
        easeOut: null,
        easing: null,
        end: null,
        fastOnEvent: 0,
        fit: 0,
        fx: "fade",
        fxFn: null,
        height: "auto",
        manualTrump: true,
        next: null,
        nowrap: 0,
        onPagerEvent: null,
        onPrevNextEvent: null,
        pager: null,
        pagerAnchorBuilder: null,
        pagerEvent: "click.cycle",
        pause: 0,
        pauseOnPagerHover: 0,
        prev: null,
        prevNextEvent: "click.cycle",
        random: 0,
        randomizeEffects: 1,
        requeueOnImageNotLoaded: true,
        requeueTimeout: 250,
        rev: 0,
        shuffle: null,
        slideExpr: null,
        slideResize: 1,
        speed: 1000,
        speedIn: null,
        speedOut: null,
        startingSlide: 0,
        sync: 1,
        timeout: 4000,
        timeoutFn: null,
        updateActivePagerLink: null
    };
})(jQuery);
/*
 * jQuery Cycle Plugin Transition Definitions
 * This script is a plugin for the jQuery Cycle Plugin
 * Examples and documentation at: http://malsup.com/jquery/cycle/
 * Copyright (c) 2007-2010 M. Alsup
 * Version:	 2.73
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 */
(function($) {
    $.fn.cycle.transitions.none = function($cont, $slides, opts) {
        opts.fxFn = function(curr, next, opts, after) {
            $(next).show();
            $(curr).hide();
            after();
        };
    };
    $.fn.cycle.transitions.fadeout = function($cont, $slides, opts) {
        $slides.not(":eq(" + opts.currSlide + ")").css({
            display: "block",
            opacity: 1
        });
        opts.before.push(function(curr, next, opts, w, h, rev) {
            $(curr).css("zIndex", opts.slideCount + (!rev === true ? 1 : 0));
            $(next).css("zIndex", opts.slideCount + (!rev === true ? 0 : 1));
        });
        opts.animIn.opacity = 1;
        opts.animOut.opacity = 0;
        opts.cssBefore.opacity = 1;
        opts.cssBefore.display = "block";
        opts.cssAfter.zIndex = 0;
    };
    $.fn.cycle.transitions.scrollUp = function($cont, $slides, opts) {
        $cont.css("overflow", "hidden");
        opts.before.push($.fn.cycle.commonReset);
        var h = $cont.height();
        opts.cssBefore.top = h;
        opts.cssBefore.left = 0;
        opts.cssFirst.top = 0;
        opts.animIn.top = 0;
        opts.animOut.top = -h;
    };
    $.fn.cycle.transitions.scrollDown = function($cont, $slides, opts) {
        $cont.css("overflow", "hidden");
        opts.before.push($.fn.cycle.commonReset);
        var h = $cont.height();
        opts.cssFirst.top = 0;
        opts.cssBefore.top = -h;
        opts.cssBefore.left = 0;
        opts.animIn.top = 0;
        opts.animOut.top = h;
    };
    $.fn.cycle.transitions.scrollLeft = function($cont, $slides, opts) {
        $cont.css("overflow", "hidden");
        opts.before.push($.fn.cycle.commonReset);
        var w = $cont.width();
        opts.cssFirst.left = 0;
        opts.cssBefore.left = w;
        opts.cssBefore.top = 0;
        opts.animIn.left = 0;
        opts.animOut.left = 0 - w;
    };
    $.fn.cycle.transitions.scrollRight = function($cont, $slides, opts) {
        $cont.css("overflow", "hidden");
        opts.before.push($.fn.cycle.commonReset);
        var w = $cont.width();
        opts.cssFirst.left = 0;
        opts.cssBefore.left = -w;
        opts.cssBefore.top = 0;
        opts.animIn.left = 0;
        opts.animOut.left = w;
    };
    $.fn.cycle.transitions.scrollHorz = function($cont, $slides, opts) {
        $cont.css("overflow", "hidden").width();
        opts.before.push(function(curr, next, opts, fwd) {
            if (opts.rev) {
                fwd = !fwd;
            }
            $.fn.cycle.commonReset(curr, next, opts);
            opts.cssBefore.left = fwd ? (next.cycleW - 1) : (1 - next.cycleW);
            opts.animOut.left = fwd ? -curr.cycleW : curr.cycleW;
        });
        opts.cssFirst.left = 0;
        opts.cssBefore.top = 0;
        opts.animIn.left = 0;
        opts.animOut.top = 0;
    };
    $.fn.cycle.transitions.scrollVert = function($cont, $slides, opts) {
        $cont.css("overflow", "hidden");
        opts.before.push(function(curr, next, opts, fwd) {
            if (opts.rev) {
                fwd = !fwd;
            }
            $.fn.cycle.commonReset(curr, next, opts);
            opts.cssBefore.top = fwd ? (1 - next.cycleH) : (next.cycleH - 1);
            opts.animOut.top = fwd ? curr.cycleH : -curr.cycleH;
        });
        opts.cssFirst.top = 0;
        opts.cssBefore.left = 0;
        opts.animIn.top = 0;
        opts.animOut.left = 0;
    };
    $.fn.cycle.transitions.slideX = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $(opts.elements).not(curr).hide();
            $.fn.cycle.commonReset(curr, next, opts, false, true);
            opts.animIn.width = next.cycleW;
        });
        opts.cssBefore.left = 0;
        opts.cssBefore.top = 0;
        opts.cssBefore.width = 0;
        opts.animIn.width = "show";
        opts.animOut.width = 0;
    };
    $.fn.cycle.transitions.slideY = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $(opts.elements).not(curr).hide();
            $.fn.cycle.commonReset(curr, next, opts, true, false);
            opts.animIn.height = next.cycleH;
        });
        opts.cssBefore.left = 0;
        opts.cssBefore.top = 0;
        opts.cssBefore.height = 0;
        opts.animIn.height = "show";
        opts.animOut.height = 0;
    };
    $.fn.cycle.transitions.shuffle = function($cont, $slides, opts) {
        var i, w = $cont.css("overflow", "visible").width();
        $slides.css({
            left: 0,
            top: 0
        });
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, true, true, true);
        });
        if (!opts.speedAdjusted) {
            opts.speed = opts.speed / 2;
            opts.speedAdjusted = true;
        }
        opts.random = 0;
        opts.shuffle = opts.shuffle || {
            left: -w,
            top: 15
        };
        opts.els = [];
        for (i = 0; i < $slides.length; i++) {
            opts.els.push($slides[i]);
        }
        for (i = 0; i < opts.currSlide; i++) {
            opts.els.push(opts.els.shift());
        }
        opts.fxFn = function(curr, next, opts, cb, fwd) {
            if (opts.rev) {
                fwd = !fwd;
            }
            var $el = fwd ? $(curr) : $(next);
            $(next).css(opts.cssBefore);
            var count = opts.slideCount;
            $el.animate(opts.shuffle, opts.speedIn, opts.easeIn, function() {
                var hops = $.fn.cycle.hopsFromLast(opts, fwd);
                for (var k = 0; k < hops; k++) {
                    fwd ? opts.els.push(opts.els.shift()) : opts.els.unshift(opts.els.pop());
                }
                if (fwd) {
                    for (var i = 0, len = opts.els.length; i < len; i++) {
                        $(opts.els[i]).css("z-index", len - i + count);
                    }
                } else {
                    var z = $(curr).css("z-index");
                    $el.css("z-index", parseInt(z) + 1 + count);
                }
                $el.animate({
                    left: 0,
                    top: 0
                }, opts.speedOut, opts.easeOut, function() {
                    $(fwd ? this : curr).hide();
                    if (cb) {
                        cb();
                    }
                });
            });
        };
        $.extend(opts.cssBefore, {
            display: "block",
            opacity: 1,
            top: 0,
            left: 0
        });
    };
    $.fn.cycle.transitions.turnUp = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, true, false);
            opts.cssBefore.top = next.cycleH;
            opts.animIn.height = next.cycleH;
            opts.animOut.width = next.cycleW;
        });
        opts.cssFirst.top = 0;
        opts.cssBefore.left = 0;
        opts.cssBefore.height = 0;
        opts.animIn.top = 0;
        opts.animOut.height = 0;
    };
    $.fn.cycle.transitions.turnDown = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, true, false);
            opts.animIn.height = next.cycleH;
            opts.animOut.top = curr.cycleH;
        });
        opts.cssFirst.top = 0;
        opts.cssBefore.left = 0;
        opts.cssBefore.top = 0;
        opts.cssBefore.height = 0;
        opts.animOut.height = 0;
    };
    $.fn.cycle.transitions.turnLeft = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, false, true);
            opts.cssBefore.left = next.cycleW;
            opts.animIn.width = next.cycleW;
        });
        opts.cssBefore.top = 0;
        opts.cssBefore.width = 0;
        opts.animIn.left = 0;
        opts.animOut.width = 0;
    };
    $.fn.cycle.transitions.turnRight = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, false, true);
            opts.animIn.width = next.cycleW;
            opts.animOut.left = curr.cycleW;
        });
        $.extend(opts.cssBefore, {
            top: 0,
            left: 0,
            width: 0
        });
        opts.animIn.left = 0;
        opts.animOut.width = 0;
    };
    $.fn.cycle.transitions.zoom = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, false, false, true);
            opts.cssBefore.top = next.cycleH / 2;
            opts.cssBefore.left = next.cycleW / 2;
            $.extend(opts.animIn, {
                top: 0,
                left: 0,
                width: next.cycleW,
                height: next.cycleH
            });
            $.extend(opts.animOut, {
                width: 0,
                height: 0,
                top: curr.cycleH / 2,
                left: curr.cycleW / 2
            });
        });
        opts.cssFirst.top = 0;
        opts.cssFirst.left = 0;
        opts.cssBefore.width = 0;
        opts.cssBefore.height = 0;
    };
    $.fn.cycle.transitions.fadeZoom = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, false, false);
            opts.cssBefore.left = next.cycleW / 2;
            opts.cssBefore.top = next.cycleH / 2;
            $.extend(opts.animIn, {
                top: 0,
                left: 0,
                width: next.cycleW,
                height: next.cycleH
            });
        });
        opts.cssBefore.width = 0;
        opts.cssBefore.height = 0;
        opts.animOut.opacity = 0;
    };
    $.fn.cycle.transitions.blindX = function($cont, $slides, opts) {
        var w = $cont.css("overflow", "hidden").width();
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts);
            opts.animIn.width = next.cycleW;
            opts.animOut.left = curr.cycleW;
        });
        opts.cssBefore.left = w;
        opts.cssBefore.top = 0;
        opts.animIn.left = 0;
        opts.animOut.left = w;
    };
    $.fn.cycle.transitions.blindY = function($cont, $slides, opts) {
        var h = $cont.css("overflow", "hidden").height();
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts);
            opts.animIn.height = next.cycleH;
            opts.animOut.top = curr.cycleH;
        });
        opts.cssBefore.top = h;
        opts.cssBefore.left = 0;
        opts.animIn.top = 0;
        opts.animOut.top = h;
    };
    $.fn.cycle.transitions.blindZ = function($cont, $slides, opts) {
        var h = $cont.css("overflow", "hidden").height();
        var w = $cont.width();
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts);
            opts.animIn.height = next.cycleH;
            opts.animOut.top = curr.cycleH;
        });
        opts.cssBefore.top = h;
        opts.cssBefore.left = w;
        opts.animIn.top = 0;
        opts.animIn.left = 0;
        opts.animOut.top = h;
        opts.animOut.left = w;
    };
    $.fn.cycle.transitions.growX = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, false, true);
            opts.cssBefore.left = this.cycleW / 2;
            opts.animIn.left = 0;
            opts.animIn.width = this.cycleW;
            opts.animOut.left = 0;
        });
        opts.cssBefore.top = 0;
        opts.cssBefore.width = 0;
    };
    $.fn.cycle.transitions.growY = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, true, false);
            opts.cssBefore.top = this.cycleH / 2;
            opts.animIn.top = 0;
            opts.animIn.height = this.cycleH;
            opts.animOut.top = 0;
        });
        opts.cssBefore.height = 0;
        opts.cssBefore.left = 0;
    };
    $.fn.cycle.transitions.curtainX = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, false, true, true);
            opts.cssBefore.left = next.cycleW / 2;
            opts.animIn.left = 0;
            opts.animIn.width = this.cycleW;
            opts.animOut.left = curr.cycleW / 2;
            opts.animOut.width = 0;
        });
        opts.cssBefore.top = 0;
        opts.cssBefore.width = 0;
    };
    $.fn.cycle.transitions.curtainY = function($cont, $slides, opts) {
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, true, false, true);
            opts.cssBefore.top = next.cycleH / 2;
            opts.animIn.top = 0;
            opts.animIn.height = next.cycleH;
            opts.animOut.top = curr.cycleH / 2;
            opts.animOut.height = 0;
        });
        opts.cssBefore.height = 0;
        opts.cssBefore.left = 0;
    };
    $.fn.cycle.transitions.cover = function($cont, $slides, opts) {
        var d = opts.direction || "left";
        var w = $cont.css("overflow", "hidden").width();
        var h = $cont.height();
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts);
            if (d == "right") {
                opts.cssBefore.left = -w;
            } else {
                if (d == "up") {
                    opts.cssBefore.top = h;
                } else {
                    if (d == "down") {
                        opts.cssBefore.top = -h;
                    } else {
                        opts.cssBefore.left = w;
                    }
                }
            }
        });
        opts.animIn.left = 0;
        opts.animIn.top = 0;
        opts.cssBefore.top = 0;
        opts.cssBefore.left = 0;
    };
    $.fn.cycle.transitions.uncover = function($cont, $slides, opts) {
        var d = opts.direction || "left";
        var w = $cont.css("overflow", "hidden").width();
        var h = $cont.height();
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, true, true, true);
            if (d == "right") {
                opts.animOut.left = w;
            } else {
                if (d == "up") {
                    opts.animOut.top = -h;
                } else {
                    if (d == "down") {
                        opts.animOut.top = h;
                    } else {
                        opts.animOut.left = -w;
                    }
                }
            }
        });
        opts.animIn.left = 0;
        opts.animIn.top = 0;
        opts.cssBefore.top = 0;
        opts.cssBefore.left = 0;
    };
    $.fn.cycle.transitions.toss = function($cont, $slides, opts) {
        var w = $cont.css("overflow", "visible").width();
        var h = $cont.height();
        opts.before.push(function(curr, next, opts) {
            $.fn.cycle.commonReset(curr, next, opts, true, true, true);
            if (!opts.animOut.left && !opts.animOut.top) {
                $.extend(opts.animOut, {
                    left: w * 2,
                    top: -h / 2,
                    opacity: 0
                });
            } else {
                opts.animOut.opacity = 0;
            }
        });
        opts.cssBefore.left = 0;
        opts.cssBefore.top = 0;
        opts.animIn.left = 0;
    };
    $.fn.cycle.transitions.wipe = function($cont, $slides, opts) {
        var w = $cont.css("overflow", "hidden").width();
        var h = $cont.height();
        opts.cssBefore = opts.cssBefore || {};
        var clip;
        if (opts.clip) {
            if (/l2r/.test(opts.clip)) {
                clip = "rect(0px 0px " + h + "px 0px)";
            } else {
                if (/r2l/.test(opts.clip)) {
                    clip = "rect(0px " + w + "px " + h + "px " + w + "px)";
                } else {
                    if (/t2b/.test(opts.clip)) {
                        clip = "rect(0px " + w + "px 0px 0px)";
                    } else {
                        if (/b2t/.test(opts.clip)) {
                            clip = "rect(" + h + "px " + w + "px " + h + "px 0px)";
                        } else {
                            if (/zoom/.test(opts.clip)) {
                                var top = parseInt(h / 2);
                                var left = parseInt(w / 2);
                                clip = "rect(" + top + "px " + left + "px " + top + "px " + left + "px)";
                            }
                        }
                    }
                }
            }
        }
        opts.cssBefore.clip = opts.cssBefore.clip || clip || "rect(0px 0px 0px 0px)";
        var d = opts.cssBefore.clip.match(/(\d+)/g);
        var t = parseInt(d[0]),
            r = parseInt(d[1]),
            b = parseInt(d[2]),
            l = parseInt(d[3]);
        opts.before.push(function(curr, next, opts) {
            if (curr == next) {
                return;
            }
            var $curr = $(curr),
                $next = $(next);
            $.fn.cycle.commonReset(curr, next, opts, true, true, false);
            opts.cssAfter.display = "block";
            var step = 1,
                count = parseInt((opts.speedIn / 13)) - 1;
            (function f() {
                var tt = t ? t - parseInt(step * (t / count)) : 0;
                var ll = l ? l - parseInt(step * (l / count)) : 0;
                var bb = b < h ? b + parseInt(step * ((h - b) / count || 1)) : h;
                var rr = r < w ? r + parseInt(step * ((w - r) / count || 1)) : w;
                $next.css({
                    clip: "rect(" + tt + "px " + rr + "px " + bb + "px " + ll + "px)"
                });
                (step++ <= count) ? setTimeout(f, 13): $curr.css("display", "none");
            })();
        });
        $.extend(opts.cssBefore, {
            display: "block",
            opacity: 1,
            top: 0,
            left: 0
        });
        opts.animIn = {
            left: 0
        };
        opts.animOut = {
            left: 0
        };
    };
})(jQuery);
/*
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
 *
 * Uses the built in easing capabilities added In jQuery 1.1
 * to offer multiple easing options
 *
 * TERMS OF USE - jQuery Easing
 * 
 * Open source under the BSD License. 
 * 
 * Copyright © 2008 George McGinley Smith
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, this list of 
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list 
 * of conditions and the following disclaimer in the documentation and/or other materials 
 * provided with the distribution.
 * 
 * Neither the name of the author nor the names of contributors may be used to endorse 
 * or promote products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
*/

// t: current time, b: begInnIng value, c: change In value, d: duration
jQuery.easing['jswing'] = jQuery.easing['swing'];

jQuery.extend( jQuery.easing,
{
	def: 'easeOutQuad',
	swing: function (x, t, b, c, d) {
		//alert(jQuery.easing.default);
		return jQuery.easing[jQuery.easing.def](x, t, b, c, d);
	},
	easeInQuad: function (x, t, b, c, d) {
		return c*(t/=d)*t + b;
	},
	easeOutQuad: function (x, t, b, c, d) {
		return -c *(t/=d)*(t-2) + b;
	},
	easeInOutQuad: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	},
	easeInCubic: function (x, t, b, c, d) {
		return c*(t/=d)*t*t + b;
	},
	easeOutCubic: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t + 1) + b;
	},
	easeInOutCubic: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	},
	easeInQuart: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t + b;
	},
	easeOutQuart: function (x, t, b, c, d) {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	},
	easeInOutQuart: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	},
	easeInQuint: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t*t + b;
	},
	easeOutQuint: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	},
	easeInOutQuint: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	},
	easeInSine: function (x, t, b, c, d) {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	},
	easeOutSine: function (x, t, b, c, d) {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	},
	easeInOutSine: function (x, t, b, c, d) {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	},
	easeInExpo: function (x, t, b, c, d) {
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
	},
	easeOutExpo: function (x, t, b, c, d) {
		return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
	},
	easeInOutExpo: function (x, t, b, c, d) {
		if (t==0) return b;
		if (t==d) return b+c;
		if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
		return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
	},
	easeInCirc: function (x, t, b, c, d) {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	},
	easeOutCirc: function (x, t, b, c, d) {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	},
	easeInOutCirc: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	},
	easeInElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	},
	easeOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
	},
	easeInOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	},
	easeInBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	},
	easeOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	},
	easeInOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158; 
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	},
	easeInBounce: function (x, t, b, c, d) {
		return c - jQuery.easing.easeOutBounce (x, d-t, 0, c, d) + b;
	},
	easeOutBounce: function (x, t, b, c, d) {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	},
	easeInOutBounce: function (x, t, b, c, d) {
		if (t < d/2) return jQuery.easing.easeInBounce (x, t*2, 0, c, d) * .5 + b;
		return jQuery.easing.easeOutBounce (x, t*2-d, 0, c, d) * .5 + c*.5 + b;
	}
});

/*
 *
 * TERMS OF USE - EASING EQUATIONS
 * 
 * Open source under the BSD License. 
 * 
 * Copyright © 2001 Robert Penner
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, this list of 
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list 
 * of conditions and the following disclaimer in the documentation and/or other materials 
 * provided with the distribution.
 * 
 * Neither the name of the author nor the names of contributors may be used to endorse 
 * or promote products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 */
/*!	
 * Maximage Version: 2.0.8 (16-Jan-2012) - http://www.aaronvanderzwan.com/maximage/2.0/
 */
(function(a) {
    a.fn.maximage = function(d, e) {
        var c;
        if (typeof d == "object" || d === undefined) {
            c = a.extend(a.fn.maximage.defaults, d || {})
        }
        if (typeof d == "string") {
            c = a.fn.maximage.defaults
        }
        a.Body = a("body");
        a.Window = a(window);
        a.Scroll = a("html, body");
        a.Events = {
            RESIZE: "resize"
        };
        this.each(function() {
            var m = a(this),
                f = 0,
                j = [];
            var i = {
                setup: function() {
                    if (a.Slides.length > 0) {
                        var r, p = a.Slides.length;
                        for (r = 0; r < p; r++) {
                            var q = a.Slides[r];
                            m.append('<div class="mc-image ' + q.theclass + '" title="' + q.alt + '" style="background-image:url(\'' + q.url + "');" + q.style + '" data-href="' + q.datahref + '">' + q.content + "</div>")
                        }
                        i.preload(0);
                        i.resize()
                    }
                },
                preload: function(q) {
                    var p = a("<img/>");
                    p.load(function() {
                        if (f == 0) {
                            g.setup();
                            c.onFirstImageLoaded()
                        }
                        if (f == (a.Slides.length - 1)) {
                            c.onImagesLoaded(m)
                        } else {
                            f++;
                            i.preload(f)
                        }
                    });
                    p[0].src = a.Slides[q].url;
                    j.push(p[0])
                },
                resize: function() {
                    a.Window.bind(a.Events.RESIZE, function() {
                        a.Scroll.addClass("mc-hide-scrolls");
                        a.Window.data("h", k.sizes().h).data("w", k.sizes().w);
                        m.height(a.Window.data("h")).width(a.Window.data("w")).children().height(a.Window.data("h")).width(a.Window.data("w"));
                        m.children().each(function() {
                            this.cycleH = a.Window.data("h");
                            this.cycleW = a.Window.data("w")
                        });
                        a(a.Scroll).removeClass("mc-hide-scrolls")
                    })
                }
            };
            var h = {
                setup: function() {
                    var u, s, q, r, p = a.Slides.length;
                    if (a.BrowserTests.msie && !c.overrideMSIEStop) {
                        document.execCommand("Stop", false)
                    }
                    m.html("");
                    a.Body.addClass("mc-old-browser");
                    if (a.Slides.length > 0) {
                        a.Scroll.addClass("mc-hide-scrolls");
                        a.Window.data("h", k.sizes().h).data("w", k.sizes().w);
                        a("body").append(a("<div></div>").attr("class", "mc-loader").css({
                            position: "absolute",
                            left: "-9999px"
                        }));
                        for (r = 0; r < p; r++) {
                            if (a.Slides[r].content.length == 0) {
                                u = '<img src="' + a.Slides[r].url + '" />'
                            } else {
                                u = a.Slides[r].content
                            }
                            q = a("<div>" + u + "</div>").attr("class", "mc-image mc-image-n" + r + " " + a.Slides[r].theclass);
                            m.append(q);
                            if (a(".mc-image-n" + r).children("img").length == 0) {} else {
                                a("div.mc-loader").append(a(".mc-image-n" + r).children("img").first().clone().addClass("not-loaded"))
                            }
                        }
                        h.preload();
                        h.windowResize()
                    }
                },
                preload: function() {
                    var p = setInterval(function() {
                        a(".mc-loader").children("img").each(function(r) {
                            var q = a(this);
                            if (q.hasClass("not-loaded")) {
                                if (q.height() > 0) {
                                    a(this).removeClass("not-loaded");
                                    var s = a("div.mc-image-n" + r).children("img").first();
                                    s.data("h", q.height()).data("w", q.width()).data("ar", (q.width() / q.height()));
                                    h.onceLoaded(r)
                                }
                            }
                        });
                        if (a(".not-loaded").length == 0) {
                            a(".mc-loader").remove();
                            clearInterval(p)
                        }
                    }, 1000)
                },
                onceLoaded: function(p) {
                    h.maximage(p);
                    if (p == 0) {
                        m.css({
                            visibility: "visible"
                        });
                        c.onFirstImageLoaded()
                    } else {
                        if (p == a.Slides.length - 1) {
                            g.setup();
                            a(a.Scroll).removeClass("mc-hide-scrolls");
                            c.onImagesLoaded(m);
                            if (c.debug) {
                                b(" - Final Maximage - ");
                                b(m)
                            }
                        }
                    }
                },
                maximage: function(q) {
                    a("div.mc-image-n" + q).height(a.Window.data("h")).width(a.Window.data("w")).children("img").first().each(function() {
                        n.maxcover(a(this))
                    })
                },
                windowResize: function() {
                    a.Window.bind(a.Events.RESIZE, function() {
                        clearTimeout(this.id);
                        this.id = setTimeout(h.doneResizing, 200)
                    })
                },
                doneResizing: function() {
                    a(a.Scroll).addClass("mc-hide-scrolls");
                    a.Window.data("h", k.sizes().h).data("w", k.sizes().w);
                    m.height(a.Window.data("h")).width(a.Window.data("w"));
                    m.find(".mc-image").each(function(q) {
                        h.maximage(q)
                    });
                    var p = m.data("cycle.opts");
                    if (p != undefined) {
                        p.height = a.Window.data("h");
                        p.width = a.Window.data("w");
                        jQuery.each(p.elements, function(q, r) {
                            r.cycleW = a.Window.data("w");
                            r.cycleH = a.Window.data("h")
                        })
                    }
                    a(a.Scroll).removeClass("mc-hide-scrolls")
                }
            };
            var g = {
                setup: function() {
                    var q, p;
                    m.addClass("mc-cycle");
                    a.Window.data("h", k.sizes().h).data("w", k.sizes().w);
                    jQuery.easing.easeForCSSTransition = function(v, w, u, A, z, y) {
                        return u + A
                    };
                    var r = a.extend({
                        fit: 1,
                        containerResize: 0,
                        height: a.Window.data("h"),
                        width: a.Window.data("w"),
                        slideResize: false,
                        easing: (a.BrowserTests.cssTransitions && c.cssTransitions ? "easeForCSSTransition" : "swing")
                    }, c.cycleOptions);
                    m.cycle(r)
                }
            };
            var n = {
                center: function(p) {
                    if (c.verticalCenter) {
                        p.css({
                            marginTop: ((p.height() - a.Window.data("h")) / 2) * -1
                        })
                    }
                    if (c.horizontalCenter) {
                        p.css({
                            marginLeft: ((p.width() - a.Window.data("w")) / 2) * -1
                        })
                    }
                },
                fill: function(p) {
                    var q = p.is("object") ? p.parent().first() : p;
                    if (typeof c.backgroundSize == "function") {
                        c.backgroundSize(p)
                    } else {
                        if (c.backgroundSize == "cover") {
                            if (a.Window.data("w") / a.Window.data("h") < q.data("ar")) {
                                p.height(a.Window.data("h")).width((a.Window.data("h") * q.data("ar")).toFixed(0))
                            } else {
                                p.height((a.Window.data("w") / q.data("ar")).toFixed(0)).width(a.Window.data("w"))
                            }
                        } else {
                            if (c.backgroundSize == "contain") {
                                if (a.Window.data("w") / a.Window.data("h") < q.data("ar")) {
                                    p.height((a.Window.data("w") / q.data("ar")).toFixed(0)).width(a.Window.data("w"))
                                } else {
                                    p.height(a.Window.data("h")).width((a.Window.data("h") * q.data("ar")).toFixed(0))
                                }
                            } else {
                                b("The backgroundSize option was not recognized for older browsers.")
                            }
                        }
                    }
                },
                maxcover: function(p) {
                    n.fill(p);
                    n.center(p)
                },
                maxcontain: function(p) {
                    n.fill(p);
                    n.center(p)
                }
            };
            var k = {
                browser_tests: function() {
                    var q = a("<div />")[0],
                        u = ["Moz", "Webkit", "Khtml", "O", "ms"],
                        t = "transition",
                        s = {
                            cssTransitions: false,
                            cssBackgroundSize: ("backgroundSize" in q.style && c.cssBackgroundSize),
                            html5Video: false,
                            msie: false
                        };
                    if (c.cssTransitions) {
                        if (typeof q.style[t] == "string") {
                            s.cssTransitions = true
                        }
                        t = t.charAt(0).toUpperCase() + t.substr(1);
                        for (var r = 0; r < u.length; r++) {
                            if (u[r] + t in q.style) {
                                s.cssTransitions = true
                            }
                        }
                    }
                    if (!!document.createElement("video").canPlayType) {
                        s.html5Video = true
                    }
                    s.msie = (k.msie() !== undefined);
                    if (c.debug) {
                        b(" - Browser Test - ");
                        b(s)
                    }
                    return s
                },
                construct_slide_object: function() {
                    var r = new Object(),
                        p = new Array(),
                        q = "";
                    m.children().each(function(t) {
                        var s = a(this).is("img") ? a(this).clone() : a(this).find("img").first().clone();
                        r = {};
                        r.url = s.attr("src");
                        r.title = s.attr("title") != undefined ? s.attr("title") : "";
                        r.alt = s.attr("alt") != undefined ? s.attr("alt") : "";
                        r.theclass = s.attr("class") != undefined ? s.attr("class") : "";
                        r.styles = s.attr("style") != undefined ? s.attr("style") : "";
                        r.orig = s.clone();
                        r.datahref = s.attr("data-href") != undefined ? s.attr("data-href") : "";
                        r.content = "";
                        if (a(this).find("img").length > 0) {
                            if (a.BrowserTests.cssBackgroundSize) {
                                a(this).find("img").first().remove()
                            }
                            r.content = a(this).html()
                        }
                        s[0].src = "";
                        if (a.BrowserTests.cssBackgroundSize) {
                            a(this).remove()
                        }
                        p.push(r)
                    });
                    if (c.debug) {
                        b(" - Slide Object - ");
                        b(p)
                    }
                    return p
                },
                msie: function() {
                    var r, p = 3,
                        s = document.createElement("div"),
                        q = s.getElementsByTagName("i");
                    while (s.innerHTML = "<!--[if gt IE " + (++p) + "]><i></i><![endif]-->", q[0]) {}
                    return p > 4 ? p : r
                },
                sizes: function() {
                    var p = {
                        h: 0,
                        w: 0
                    };
                    if (c.fillElement == "window") {
                        p.h = a.Window.height();
                        p.w = a.Window.width()
                    } else {
                        var q = m.parents(c.fillElement).first();
                        if (q.height() == 0 || q.data("windowHeight") == true) {
                            q.data("windowHeight", true);
                            p.h = a.Window.height()
                        } else {
                            p.h = q.height()
                        }
                        if (q.width() == 0 || q.data("windowWidth") == true) {
                            q.data("windowWidth", true);
                            p.w = a.Window.width()
                        } else {
                            p.w = q.width()
                        }
                    }
                    return p
                }
            };
            a.BrowserTests = k.browser_tests();
            if (typeof d == "string") {
                if (a.BrowserTests.html5Video || !m.is("video")) {
                    var l, o = m.is("object") ? m.parent().first() : m;
                    if (!a.Body.hasClass("mc-old-browser")) {
                        a.Body.addClass("mc-old-browser")
                    }
                    a.Window.data("h", k.sizes().h).data("w", k.sizes().w);
                    o.data("h", m.height()).data("w", m.width()).data("ar", m.width() / m.height());
                    a.Window.bind(a.Events.RESIZE, function() {
                        a.Window.data("h", k.sizes().h).data("w", k.sizes().w);
                        l = m.data("resizer");
                        clearTimeout(l);
                        l = setTimeout(n[d](m), 200);
                        m.data("resizer", l)
                    });
                    n[d](m)
                }
            } else {
                a.Slides = k.construct_slide_object();
                if (a.BrowserTests.cssBackgroundSize) {
                    if (c.debug) {
                        b(" - Using Modern - ")
                    }
                    i.setup()
                } else {
                    if (c.debug) {
                        b(" - Using Old - ")
                    }
                    h.setup()
                }
            }
        });

        function b(f) {
            if (window.console && window.console.log) {
                window.console.log(f)
            }
        }
    };
    a.fn.maximage.defaults = {
        debug: false,
        cssBackgroundSize: true,
        cssTransitions: true,
        verticalCenter: true,
        horizontalCenter: true,
        scaleInterval: 20,
        backgroundSize: "cover",
        fillElement: "window",
        overrideMSIEStop: false,
        onFirstImageLoaded: function() {},
        onImagesLoaded: function() {}
    }
})(jQuery);
/* ========================================================================
 * bootstrap-switch - v3.3.2
 * http://www.bootstrap-switch.org
 * ========================================================================
 * Copyright 2012-2013 Mattia Larentis
 *
 * ========================================================================
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================================
 */

(function() {
  var slice = [].slice;

  (function($, window) {
    "use strict";
    var BootstrapSwitch;
    BootstrapSwitch = (function() {
      function BootstrapSwitch(element, options) {
        if (options == null) {
          options = {};
        }
        this.$element = $(element);
        this.options = $.extend({}, $.fn.bootstrapSwitch.defaults, {
          state: this.$element.is(":checked"),
          size: this.$element.data("size"),
          animate: this.$element.data("animate"),
          disabled: this.$element.is(":disabled"),
          readonly: this.$element.is("[readonly]"),
          indeterminate: this.$element.data("indeterminate"),
          inverse: this.$element.data("inverse"),
          radioAllOff: this.$element.data("radio-all-off"),
          onColor: this.$element.data("on-color"),
          offColor: this.$element.data("off-color"),
          onText: this.$element.data("on-text"),
          offText: this.$element.data("off-text"),
          labelText: this.$element.data("label-text"),
          handleWidth: this.$element.data("handle-width"),
          labelWidth: this.$element.data("label-width"),
          baseClass: this.$element.data("base-class"),
          wrapperClass: this.$element.data("wrapper-class")
        }, options);
        this.prevOptions = {};
        this.$wrapper = $("<div>", {
          "class": (function(_this) {
            return function() {
              var classes;
              classes = ["" + _this.options.baseClass].concat(_this._getClasses(_this.options.wrapperClass));
              classes.push(_this.options.state ? _this.options.baseClass + "-on" : _this.options.baseClass + "-off");
              if (_this.options.size != null) {
                classes.push(_this.options.baseClass + "-" + _this.options.size);
              }
              if (_this.options.disabled) {
                classes.push(_this.options.baseClass + "-disabled");
              }
              if (_this.options.readonly) {
                classes.push(_this.options.baseClass + "-readonly");
              }
              if (_this.options.indeterminate) {
                classes.push(_this.options.baseClass + "-indeterminate");
              }
              if (_this.options.inverse) {
                classes.push(_this.options.baseClass + "-inverse");
              }
              if (_this.$element.attr("id")) {
                classes.push(_this.options.baseClass + "-id-" + (_this.$element.attr("id")));
              }
              return classes.join(" ");
            };
          })(this)()
        });
        this.$container = $("<div>", {
          "class": this.options.baseClass + "-container"
        });
        this.$on = $("<span>", {
          html: this.options.onText,
          "class": this.options.baseClass + "-handle-on " + this.options.baseClass + "-" + this.options.onColor
        });
        this.$off = $("<span>", {
          html: this.options.offText,
          "class": this.options.baseClass + "-handle-off " + this.options.baseClass + "-" + this.options.offColor
        });
        this.$label = $("<span>", {
          html: this.options.labelText,
          "class": this.options.baseClass + "-label"
        });
        this.$element.on("init.bootstrapSwitch", (function(_this) {
          return function() {
            return _this.options.onInit.apply(element, arguments);
          };
        })(this));
        this.$element.on("switchChange.bootstrapSwitch", (function(_this) {
          return function(e) {
            if (false === _this.options.onSwitchChange.apply(element, arguments)) {
              if (_this.$element.is(":radio")) {
                return $("[name='" + (_this.$element.attr('name')) + "']").trigger("previousState.bootstrapSwitch", true);
              } else {
                return _this.$element.trigger("previousState.bootstrapSwitch", true);
              }
            }
          };
        })(this));
        this.$container = this.$element.wrap(this.$container).parent();
        this.$wrapper = this.$container.wrap(this.$wrapper).parent();
        this.$element.before(this.options.inverse ? this.$off : this.$on).before(this.$label).before(this.options.inverse ? this.$on : this.$off);
        if (this.options.indeterminate) {
          this.$element.prop("indeterminate", true);
        }
        this._init();
        this._elementHandlers();
        this._handleHandlers();
        this._labelHandlers();
        this._formHandler();
        this._externalLabelHandler();
        this.$element.trigger("init.bootstrapSwitch", this.options.state);
      }

      BootstrapSwitch.prototype._constructor = BootstrapSwitch;

      BootstrapSwitch.prototype.setPrevOptions = function() {
        return this.prevOptions = $.extend(true, {}, this.options);
      };

      BootstrapSwitch.prototype.state = function(value, skip) {
        if (typeof value === "undefined") {
          return this.options.state;
        }
        if (this.options.disabled || this.options.readonly) {
          return this.$element;
        }
        if (this.options.state && !this.options.radioAllOff && this.$element.is(":radio")) {
          return this.$element;
        }
        if (this.$element.is(":radio")) {
          $("[name='" + (this.$element.attr('name')) + "']").trigger("setPreviousOptions.bootstrapSwitch");
        } else {
          this.$element.trigger("setPreviousOptions.bootstrapSwitch");
        }
        if (this.options.indeterminate) {
          this.indeterminate(false);
        }
        value = !!value;
        this.$element.prop("checked", value).trigger("change.bootstrapSwitch", skip);
        return this.$element;
      };

      BootstrapSwitch.prototype.toggleState = function(skip) {
        if (this.options.disabled || this.options.readonly) {
          return this.$element;
        }
        if (this.options.indeterminate) {
          this.indeterminate(false);
          return this.state(true);
        } else {
          return this.$element.prop("checked", !this.options.state).trigger("change.bootstrapSwitch", skip);
        }
      };

      BootstrapSwitch.prototype.size = function(value) {
        if (typeof value === "undefined") {
          return this.options.size;
        }
        if (this.options.size != null) {
          this.$wrapper.removeClass(this.options.baseClass + "-" + this.options.size);
        }
        if (value) {
          this.$wrapper.addClass(this.options.baseClass + "-" + value);
        }
        this._width();
        this._containerPosition();
        this.options.size = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.animate = function(value) {
        if (typeof value === "undefined") {
          return this.options.animate;
        }
        value = !!value;
        if (value === this.options.animate) {
          return this.$element;
        }
        return this.toggleAnimate();
      };

      BootstrapSwitch.prototype.toggleAnimate = function() {
        this.options.animate = !this.options.animate;
        this.$wrapper.toggleClass(this.options.baseClass + "-animate");
        return this.$element;
      };

      BootstrapSwitch.prototype.disabled = function(value) {
        if (typeof value === "undefined") {
          return this.options.disabled;
        }
        value = !!value;
        if (value === this.options.disabled) {
          return this.$element;
        }
        return this.toggleDisabled();
      };

      BootstrapSwitch.prototype.toggleDisabled = function() {
        this.options.disabled = !this.options.disabled;
        this.$element.prop("disabled", this.options.disabled);
        this.$wrapper.toggleClass(this.options.baseClass + "-disabled");
        return this.$element;
      };

      BootstrapSwitch.prototype.readonly = function(value) {
        if (typeof value === "undefined") {
          return this.options.readonly;
        }
        value = !!value;
        if (value === this.options.readonly) {
          return this.$element;
        }
        return this.toggleReadonly();
      };

      BootstrapSwitch.prototype.toggleReadonly = function() {
        this.options.readonly = !this.options.readonly;
        this.$element.prop("readonly", this.options.readonly);
        this.$wrapper.toggleClass(this.options.baseClass + "-readonly");
        return this.$element;
      };

      BootstrapSwitch.prototype.indeterminate = function(value) {
        if (typeof value === "undefined") {
          return this.options.indeterminate;
        }
        value = !!value;
        if (value === this.options.indeterminate) {
          return this.$element;
        }
        return this.toggleIndeterminate();
      };

      BootstrapSwitch.prototype.toggleIndeterminate = function() {
        this.options.indeterminate = !this.options.indeterminate;
        this.$element.prop("indeterminate", this.options.indeterminate);
        this.$wrapper.toggleClass(this.options.baseClass + "-indeterminate");
        this._containerPosition();
        return this.$element;
      };

      BootstrapSwitch.prototype.inverse = function(value) {
        if (typeof value === "undefined") {
          return this.options.inverse;
        }
        value = !!value;
        if (value === this.options.inverse) {
          return this.$element;
        }
        return this.toggleInverse();
      };

      BootstrapSwitch.prototype.toggleInverse = function() {
        var $off, $on;
        this.$wrapper.toggleClass(this.options.baseClass + "-inverse");
        $on = this.$on.clone(true);
        $off = this.$off.clone(true);
        this.$on.replaceWith($off);
        this.$off.replaceWith($on);
        this.$on = $off;
        this.$off = $on;
        this.options.inverse = !this.options.inverse;
        return this.$element;
      };

      BootstrapSwitch.prototype.onColor = function(value) {
        var color;
        color = this.options.onColor;
        if (typeof value === "undefined") {
          return color;
        }
        if (color != null) {
          this.$on.removeClass(this.options.baseClass + "-" + color);
        }
        this.$on.addClass(this.options.baseClass + "-" + value);
        this.options.onColor = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.offColor = function(value) {
        var color;
        color = this.options.offColor;
        if (typeof value === "undefined") {
          return color;
        }
        if (color != null) {
          this.$off.removeClass(this.options.baseClass + "-" + color);
        }
        this.$off.addClass(this.options.baseClass + "-" + value);
        this.options.offColor = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.onText = function(value) {
        if (typeof value === "undefined") {
          return this.options.onText;
        }
        this.$on.html(value);
        this._width();
        this._containerPosition();
        this.options.onText = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.offText = function(value) {
        if (typeof value === "undefined") {
          return this.options.offText;
        }
        this.$off.html(value);
        this._width();
        this._containerPosition();
        this.options.offText = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.labelText = function(value) {
        if (typeof value === "undefined") {
          return this.options.labelText;
        }
        this.$label.html(value);
        this._width();
        this.options.labelText = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.handleWidth = function(value) {
        if (typeof value === "undefined") {
          return this.options.handleWidth;
        }
        this.options.handleWidth = value;
        this._width();
        this._containerPosition();
        return this.$element;
      };

      BootstrapSwitch.prototype.labelWidth = function(value) {
        if (typeof value === "undefined") {
          return this.options.labelWidth;
        }
        this.options.labelWidth = value;
        this._width();
        this._containerPosition();
        return this.$element;
      };

      BootstrapSwitch.prototype.baseClass = function(value) {
        return this.options.baseClass;
      };

      BootstrapSwitch.prototype.wrapperClass = function(value) {
        if (typeof value === "undefined") {
          return this.options.wrapperClass;
        }
        if (!value) {
          value = $.fn.bootstrapSwitch.defaults.wrapperClass;
        }
        this.$wrapper.removeClass(this._getClasses(this.options.wrapperClass).join(" "));
        this.$wrapper.addClass(this._getClasses(value).join(" "));
        this.options.wrapperClass = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.radioAllOff = function(value) {
        if (typeof value === "undefined") {
          return this.options.radioAllOff;
        }
        value = !!value;
        if (value === this.options.radioAllOff) {
          return this.$element;
        }
        this.options.radioAllOff = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.onInit = function(value) {
        if (typeof value === "undefined") {
          return this.options.onInit;
        }
        if (!value) {
          value = $.fn.bootstrapSwitch.defaults.onInit;
        }
        this.options.onInit = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.onSwitchChange = function(value) {
        if (typeof value === "undefined") {
          return this.options.onSwitchChange;
        }
        if (!value) {
          value = $.fn.bootstrapSwitch.defaults.onSwitchChange;
        }
        this.options.onSwitchChange = value;
        return this.$element;
      };

      BootstrapSwitch.prototype.destroy = function() {
        var $form;
        $form = this.$element.closest("form");
        if ($form.length) {
          $form.off("reset.bootstrapSwitch").removeData("bootstrap-switch");
        }
        this.$container.children().not(this.$element).remove();
        this.$element.unwrap().unwrap().off(".bootstrapSwitch").removeData("bootstrap-switch");
        return this.$element;
      };

      BootstrapSwitch.prototype._width = function() {
        var $handles, handleWidth;
        $handles = this.$on.add(this.$off);
        $handles.add(this.$label).css("width", "");
        handleWidth = this.options.handleWidth === "auto" ? Math.max(this.$on.width(), this.$off.width()) : this.options.handleWidth;
        $handles.width(handleWidth);
        this.$label.width((function(_this) {
          return function(index, width) {
            if (_this.options.labelWidth !== "auto") {
              return _this.options.labelWidth;
            }
            if (width < handleWidth) {
              return handleWidth;
            } else {
              return width;
            }
          };
        })(this));
        this._handleWidth = this.$on.outerWidth();
        this._labelWidth = this.$label.outerWidth();
        this.$container.width((this._handleWidth * 2) + this._labelWidth);
        return this.$wrapper.width(this._handleWidth + this._labelWidth);
      };

      BootstrapSwitch.prototype._containerPosition = function(state, callback) {
        if (state == null) {
          state = this.options.state;
        }
        this.$container.css("margin-left", (function(_this) {
          return function() {
            var values;
            values = [0, "-" + _this._handleWidth + "px"];
            if (_this.options.indeterminate) {
              return "-" + (_this._handleWidth / 2) + "px";
            }
            if (state) {
              if (_this.options.inverse) {
                return values[1];
              } else {
                return values[0];
              }
            } else {
              if (_this.options.inverse) {
                return values[0];
              } else {
                return values[1];
              }
            }
          };
        })(this));
        if (!callback) {
          return;
        }
        return setTimeout(function() {
          return callback();
        }, 50);
      };

      BootstrapSwitch.prototype._init = function() {
        var init, initInterval;
        init = (function(_this) {
          return function() {
            _this.setPrevOptions();
            _this._width();
            return _this._containerPosition(null, function() {
              if (_this.options.animate) {
                return _this.$wrapper.addClass(_this.options.baseClass + "-animate");
              }
            });
          };
        })(this);
        if (this.$wrapper.is(":visible")) {
          return init();
        }
        return initInterval = window.setInterval((function(_this) {
          return function() {
            if (_this.$wrapper.is(":visible")) {
              init();
              return window.clearInterval(initInterval);
            }
          };
        })(this), 50);
      };

      BootstrapSwitch.prototype._elementHandlers = function() {
        return this.$element.on({
          "setPreviousOptions.bootstrapSwitch": (function(_this) {
            return function(e) {
              return _this.setPrevOptions();
            };
          })(this),
          "previousState.bootstrapSwitch": (function(_this) {
            return function(e) {
              _this.options = _this.prevOptions;
              if (_this.options.indeterminate) {
                _this.$wrapper.addClass(_this.options.baseClass + "-indeterminate");
              }
              return _this.$element.prop("checked", _this.options.state).trigger("change.bootstrapSwitch", true);
            };
          })(this),
          "change.bootstrapSwitch": (function(_this) {
            return function(e, skip) {
              var state;
              e.preventDefault();
              e.stopImmediatePropagation();
              state = _this.$element.is(":checked");
              _this._containerPosition(state);
              if (state === _this.options.state) {
                return;
              }
              _this.options.state = state;
              _this.$wrapper.toggleClass(_this.options.baseClass + "-off").toggleClass(_this.options.baseClass + "-on");
              if (!skip) {
                if (_this.$element.is(":radio")) {
                  $("[name='" + (_this.$element.attr('name')) + "']").not(_this.$element).prop("checked", false).trigger("change.bootstrapSwitch", true);
                }
                return _this.$element.trigger("switchChange.bootstrapSwitch", [state]);
              }
            };
          })(this),
          "focus.bootstrapSwitch": (function(_this) {
            return function(e) {
              e.preventDefault();
              return _this.$wrapper.addClass(_this.options.baseClass + "-focused");
            };
          })(this),
          "blur.bootstrapSwitch": (function(_this) {
            return function(e) {
              e.preventDefault();
              return _this.$wrapper.removeClass(_this.options.baseClass + "-focused");
            };
          })(this),
          "keydown.bootstrapSwitch": (function(_this) {
            return function(e) {
              if (!e.which || _this.options.disabled || _this.options.readonly) {
                return;
              }
              switch (e.which) {
                case 37:
                  e.preventDefault();
                  e.stopImmediatePropagation();
                  return _this.state(false);
                case 39:
                  e.preventDefault();
                  e.stopImmediatePropagation();
                  return _this.state(true);
              }
            };
          })(this)
        });
      };

      BootstrapSwitch.prototype._handleHandlers = function() {
        this.$on.on("click.bootstrapSwitch", (function(_this) {
          return function(event) {
            event.preventDefault();
            event.stopPropagation();
            _this.state(false);
            return _this.$element.trigger("focus.bootstrapSwitch");
          };
        })(this));
        return this.$off.on("click.bootstrapSwitch", (function(_this) {
          return function(event) {
            event.preventDefault();
            event.stopPropagation();
            _this.state(true);
            return _this.$element.trigger("focus.bootstrapSwitch");
          };
        })(this));
      };

      BootstrapSwitch.prototype._labelHandlers = function() {
        return this.$label.on({
          "click": function(e) {
            return e.stopPropagation();
          },
          "mousedown.bootstrapSwitch touchstart.bootstrapSwitch": (function(_this) {
            return function(e) {
              if (_this._dragStart || _this.options.disabled || _this.options.readonly) {
                return;
              }
              e.preventDefault();
              e.stopPropagation();
              _this._dragStart = (e.pageX || e.originalEvent.touches[0].pageX) - parseInt(_this.$container.css("margin-left"), 10);
              if (_this.options.animate) {
                _this.$wrapper.removeClass(_this.options.baseClass + "-animate");
              }
              return _this.$element.trigger("focus.bootstrapSwitch");
            };
          })(this),
          "mousemove.bootstrapSwitch touchmove.bootstrapSwitch": (function(_this) {
            return function(e) {
              var difference;
              if (_this._dragStart == null) {
                return;
              }
              e.preventDefault();
              difference = (e.pageX || e.originalEvent.touches[0].pageX) - _this._dragStart;
              if (difference < -_this._handleWidth || difference > 0) {
                return;
              }
              _this._dragEnd = difference;
              return _this.$container.css("margin-left", _this._dragEnd + "px");
            };
          })(this),
          "mouseup.bootstrapSwitch touchend.bootstrapSwitch": (function(_this) {
            return function(e) {
              var state;
              if (!_this._dragStart) {
                return;
              }
              e.preventDefault();
              if (_this.options.animate) {
                _this.$wrapper.addClass(_this.options.baseClass + "-animate");
              }
              if (_this._dragEnd) {
                state = _this._dragEnd > -(_this._handleWidth / 2);
                _this._dragEnd = false;
                _this.state(_this.options.inverse ? !state : state);
              } else {
                _this.state(!_this.options.state);
              }
              return _this._dragStart = false;
            };
          })(this),
          "mouseleave.bootstrapSwitch": (function(_this) {
            return function(e) {
              return _this.$label.trigger("mouseup.bootstrapSwitch");
            };
          })(this)
        });
      };

      BootstrapSwitch.prototype._externalLabelHandler = function() {
        var $externalLabel;
        $externalLabel = this.$element.closest("label");
        return $externalLabel.on("click", (function(_this) {
          return function(event) {
            event.preventDefault();
            event.stopImmediatePropagation();
            if (event.target === $externalLabel[0]) {
              return _this.toggleState();
            }
          };
        })(this));
      };

      BootstrapSwitch.prototype._formHandler = function() {
        var $form;
        $form = this.$element.closest("form");
        if ($form.data("bootstrap-switch")) {
          return;
        }
        return $form.on("reset.bootstrapSwitch", function() {
          return window.setTimeout(function() {
            return $form.find("input").filter(function() {
              return $(this).data("bootstrap-switch");
            }).each(function() {
              return $(this).bootstrapSwitch("state", this.checked);
            });
          }, 1);
        }).data("bootstrap-switch", true);
      };

      BootstrapSwitch.prototype._getClasses = function(classes) {
        var c, cls, i, len;
        if (!$.isArray(classes)) {
          return [this.options.baseClass + "-" + classes];
        }
        cls = [];
        for (i = 0, len = classes.length; i < len; i++) {
          c = classes[i];
          cls.push(this.options.baseClass + "-" + c);
        }
        return cls;
      };

      return BootstrapSwitch;

    })();
    $.fn.bootstrapSwitch = function() {
      var args, option, ret;
      option = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      ret = this;
      this.each(function() {
        var $this, data;
        $this = $(this);
        data = $this.data("bootstrap-switch");
        if (!data) {
          $this.data("bootstrap-switch", data = new BootstrapSwitch(this, option));
        }
        if (typeof option === "string") {
          return ret = data[option].apply(data, args);
        }
      });
      return ret;
    };
    $.fn.bootstrapSwitch.Constructor = BootstrapSwitch;
    return $.fn.bootstrapSwitch.defaults = {
      state: true,
      size: null,
      animate: true,
      disabled: false,
      readonly: false,
      indeterminate: false,
      inverse: false,
      radioAllOff: false,
      onColor: "primary",
      offColor: "default",
      onText: "ON",
      offText: "OFF",
      labelText: "&nbsp;",
      handleWidth: "auto",
      labelWidth: "auto",
      baseClass: "bootstrap-switch",
      wrapperClass: "wrapper",
      onInit: function() {},
      onSwitchChange: function() {}
    };
  })(window.jQuery, window);

}).call(this);

/**
 * @preserve jQuery DateTimePicker plugin v2.4.5
 * @homepage http://xdsoft.net/jqplugins/datetimepicker/
 * (c) 2014, Chupurnov Valeriy.
 */
/*global document,window,jQuery,setTimeout,clearTimeout,HighlightedDate,getCurrentValue*/
(function ($) {
	'use strict';
	var default_options  = {
		i18n: {
			ar: { // Arabic
				months: [
					"كانون الثاني", "شباط", "آذار", "نيسان", "مايو", "حزيران", "تموز", "آب", "أيلول", "تشرين الأول", "تشرين الثاني", "كانون الأول"
				],
				dayOfWeek: [
					"ن", "ث", "ع", "خ", "ج", "س", "ح"
				]
			},
			ro: { // Romanian
				months: [
					"ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "august", "septembrie", "octombrie", "noiembrie", "decembrie"
				],
				dayOfWeek: [
					"l", "ma", "mi", "j", "v", "s", "d"
				]
			},
			id: { // Indonesian
				months: [
					"Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"
				],
				dayOfWeek: [
					"Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"
				]
			},
			is: { // Icelandic
				months: [
					"Janúar", "Febrúar", "Mars", "Apríl", "Maí", "Júní", "Júlí", "Ágúst", "September", "Október", "Nóvember", "Desember"
				],
				dayOfWeek: [
					"Sun", "Mán", "Þrið", "Mið", "Fim", "Fös", "Lau"
				]
			},
			bg: { // Bulgarian
				months: [
					"Януари", "Февруари", "Март", "Април", "Май", "Юни", "Юли", "Август", "Септември", "Октомври", "Ноември", "Декември"
				],
				dayOfWeek: [
					"Нд", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"
				]
			},
			fa: { // Persian/Farsi
				months: [
					'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور', 'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
				],
				dayOfWeek: [
					'یکشنبه', 'دوشنبه', 'سه شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه', 'شنبه'
				]
			},
			ru: { // Russian
				months: [
					'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
				],
				dayOfWeek: [
					"Вск", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"
				]
			},
			uk: { // Ukrainian
				months: [
					'Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'
				],
				dayOfWeek: [
					"Ндл", "Пнд", "Втр", "Срд", "Чтв", "Птн", "Сбт"
				]
			},
			en: { // English
				months: [
					"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
				],
				dayOfWeek: [
					"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
				]
			},
			el: { // Ελληνικά
				months: [
					"Ιανουάριος", "Φεβρουάριος", "Μάρτιος", "Απρίλιος", "Μάιος", "Ιούνιος", "Ιούλιος", "Αύγουστος", "Σεπτέμβριος", "Οκτώβριος", "Νοέμβριος", "Δεκέμβριος"
				],
				dayOfWeek: [
					"Κυρ", "Δευ", "Τρι", "Τετ", "Πεμ", "Παρ", "Σαβ"
				]
			},
			de: { // German
				months: [
					'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'
				],
				dayOfWeek: [
					"So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"
				]
			},
			nl: { // Dutch
				months: [
					"januari", "februari", "maart", "april", "mei", "juni", "juli", "augustus", "september", "oktober", "november", "december"
				],
				dayOfWeek: [
					"zo", "ma", "di", "wo", "do", "vr", "za"
				]
			},
			tr: { // Turkish
				months: [
					"Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
				],
				dayOfWeek: [
					"Paz", "Pts", "Sal", "Çar", "Per", "Cum", "Cts"
				]
			},
			fr: { //French
				months: [
					"Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
				],
				dayOfWeek: [
					"Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"
				]
			},
			es: { // Spanish
				months: [
					"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
				],
				dayOfWeek: [
					"Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"
				]
			},
			th: { // Thai
				months: [
					'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน', 'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
				],
				dayOfWeek: [
					'อา.', 'จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.'
				]
			},
			pl: { // Polish
				months: [
					"styczeń", "luty", "marzec", "kwiecień", "maj", "czerwiec", "lipiec", "sierpień", "wrzesień", "październik", "listopad", "grudzień"
				],
				dayOfWeek: [
					"nd", "pn", "wt", "śr", "cz", "pt", "sb"
				]
			},
			pt: { // Portuguese
				months: [
					"Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
				],
				dayOfWeek: [
					"Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"
				]
			},
			ch: { // Simplified Chinese
				months: [
					"一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"
				],
				dayOfWeek: [
					"日", "一", "二", "三", "四", "五", "六"
				]
			},
			se: { // Swedish
				months: [
					"Januari", "Februari", "Mars", "April", "Maj", "Juni", "Juli", "Augusti", "September",  "Oktober", "November", "December"
				],
				dayOfWeek: [
					"Sön", "Mån", "Tis", "Ons", "Tor", "Fre", "Lör"
				]
			},
			kr: { // Korean
				months: [
					"1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"
				],
				dayOfWeek: [
					"일", "월", "화", "수", "목", "금", "토"
				]
			},
			it: { // Italian
				months: [
					"Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"
				],
				dayOfWeek: [
					"Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"
				]
			},
			da: { // Dansk
				months: [
					"January", "Februar", "Marts", "April", "Maj", "Juni", "July", "August", "September", "Oktober", "November", "December"
				],
				dayOfWeek: [
					"Søn", "Man", "Tir", "Ons", "Tor", "Fre", "Lør"
				]
			},
			no: { // Norwegian
				months: [
					"Januar", "Februar", "Mars", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Desember"
				],
				dayOfWeek: [
					"Søn", "Man", "Tir", "Ons", "Tor", "Fre", "Lør"
				]
			},
			ja: { // Japanese
				months: [
					"1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"
				],
				dayOfWeek: [
					"日", "月", "火", "水", "木", "金", "土"
				]
			},
			vi: { // Vietnamese
				months: [
					"Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"
				],
				dayOfWeek: [
					"CN", "T2", "T3", "T4", "T5", "T6", "T7"
				]
			},
			sl: { // Slovenščina
				months: [
					"Januar", "Februar", "Marec", "April", "Maj", "Junij", "Julij", "Avgust", "September", "Oktober", "November", "December"
				],
				dayOfWeek: [
					"Ned", "Pon", "Tor", "Sre", "Čet", "Pet", "Sob"
				]
			},
			cs: { // Čeština
				months: [
					"Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec"
				],
				dayOfWeek: [
					"Ne", "Po", "Út", "St", "Čt", "Pá", "So"
				]
			},
			hu: { // Hungarian
				months: [
					"Január", "Február", "Március", "Április", "Május", "Június", "Július", "Augusztus", "Szeptember", "Október", "November", "December"
				],
				dayOfWeek: [
					"Va", "Hé", "Ke", "Sze", "Cs", "Pé", "Szo"
				]
			},
			az: { //Azerbaijanian (Azeri)
				months: [
					"Yanvar", "Fevral", "Mart", "Aprel", "May", "Iyun", "Iyul", "Avqust", "Sentyabr", "Oktyabr", "Noyabr", "Dekabr"
				],
				dayOfWeek: [
					"B", "Be", "Ça", "Ç", "Ca", "C", "Ş"
				]
			},
			bs: { //Bosanski
				months: [
					"Januar", "Februar", "Mart", "April", "Maj", "Jun", "Jul", "Avgust", "Septembar", "Oktobar", "Novembar", "Decembar"
				],
				dayOfWeek: [
					"Ned", "Pon", "Uto", "Sri", "Čet", "Pet", "Sub"
				]
			},
			ca: { //Català
				months: [
					"Gener", "Febrer", "Març", "Abril", "Maig", "Juny", "Juliol", "Agost", "Setembre", "Octubre", "Novembre", "Desembre"
				],
				dayOfWeek: [
					"Dg", "Dl", "Dt", "Dc", "Dj", "Dv", "Ds"
				]
			},
			'en-GB': { //English (British)
				months: [
					"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
				],
				dayOfWeek: [
					"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
				]
			},
			et: { //"Eesti"
				months: [
					"Jaanuar", "Veebruar", "Märts", "Aprill", "Mai", "Juuni", "Juuli", "August", "September", "Oktoober", "November", "Detsember"
				],
				dayOfWeek: [
					"P", "E", "T", "K", "N", "R", "L"
				]
			},
			eu: { //Euskara
				months: [
					"Urtarrila", "Otsaila", "Martxoa", "Apirila", "Maiatza", "Ekaina", "Uztaila", "Abuztua", "Iraila", "Urria", "Azaroa", "Abendua"
				],
				dayOfWeek: [
					"Ig.", "Al.", "Ar.", "Az.", "Og.", "Or.", "La."
				]
			},
			fi: { //Finnish (Suomi)
				months: [
					"Tammikuu", "Helmikuu", "Maaliskuu", "Huhtikuu", "Toukokuu", "Kesäkuu", "Heinäkuu", "Elokuu", "Syyskuu", "Lokakuu", "Marraskuu", "Joulukuu"
				],
				dayOfWeek: [
					"Su", "Ma", "Ti", "Ke", "To", "Pe", "La"
				]
			},
			gl: { //Galego
				months: [
					"Xan", "Feb", "Maz", "Abr", "Mai", "Xun", "Xul", "Ago", "Set", "Out", "Nov", "Dec"
				],
				dayOfWeek: [
					"Dom", "Lun", "Mar", "Mer", "Xov", "Ven", "Sab"
				]
			},
			hr: { //Hrvatski
				months: [
					"Siječanj", "Veljača", "Ožujak", "Travanj", "Svibanj", "Lipanj", "Srpanj", "Kolovoz", "Rujan", "Listopad", "Studeni", "Prosinac"
				],
				dayOfWeek: [
					"Ned", "Pon", "Uto", "Sri", "Čet", "Pet", "Sub"
				]
			},
			ko: { //Korean (한국어)
				months: [
					"1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"
				],
				dayOfWeek: [
					"일", "월", "화", "수", "목", "금", "토"
				]
			},
			lt: { //Lithuanian (lietuvių)
				months: [
					"Sausio", "Vasario", "Kovo", "Balandžio", "Gegužės", "Birželio", "Liepos", "Rugpjūčio", "Rugsėjo", "Spalio", "Lapkričio", "Gruodžio"
				],
				dayOfWeek: [
					"Sek", "Pir", "Ant", "Tre", "Ket", "Pen", "Šeš"
				]
			},
			lv: { //Latvian (Latviešu)
				months: [
					"Janvāris", "Februāris", "Marts", "Aprīlis ", "Maijs", "Jūnijs", "Jūlijs", "Augusts", "Septembris", "Oktobris", "Novembris", "Decembris"
				],
				dayOfWeek: [
					"Sv", "Pr", "Ot", "Tr", "Ct", "Pk", "St"
				]
			},
			mk: { //Macedonian (Македонски)
				months: [
					"јануари", "февруари", "март", "април", "мај", "јуни", "јули", "август", "септември", "октомври", "ноември", "декември"
				],
				dayOfWeek: [
					"нед", "пон", "вто", "сре", "чет", "пет", "саб"
				]
			},
			mn: { //Mongolian (Монгол)
				months: [
					"1-р сар", "2-р сар", "3-р сар", "4-р сар", "5-р сар", "6-р сар", "7-р сар", "8-р сар", "9-р сар", "10-р сар", "11-р сар", "12-р сар"
				],
				dayOfWeek: [
					"Дав", "Мяг", "Лха", "Пүр", "Бсн", "Бям", "Ням"
				]
			},
			'pt-BR': { //Português(Brasil)
				months: [
					"Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
				],
				dayOfWeek: [
					"Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"
				]
			},
			sk: { //Slovenčina
				months: [
					"Január", "Február", "Marec", "Apríl", "Máj", "Jún", "Júl", "August", "September", "Október", "November", "December"
				],
				dayOfWeek: [
					"Ne", "Po", "Ut", "St", "Št", "Pi", "So"
				]
			},
			sq: { //Albanian (Shqip)
				months: [
					"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
				],
				dayOfWeek: [
					"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
				]
			},
			'sr-YU': { //Serbian (Srpski)
				months: [
					"Januar", "Februar", "Mart", "April", "Maj", "Jun", "Jul", "Avgust", "Septembar", "Oktobar", "Novembar", "Decembar"
				],
				dayOfWeek: [
					"Ned", "Pon", "Uto", "Sre", "čet", "Pet", "Sub"
				]
			},
			sr: { //Serbian Cyrillic (Српски)
				months: [
					"јануар", "фебруар", "март", "април", "мај", "јун", "јул", "август", "септембар", "октобар", "новембар", "децембар"
				],
				dayOfWeek: [
					"нед", "пон", "уто", "сре", "чет", "пет", "суб"
				]
			},
			sv: { //Svenska
				months: [
					"Januari", "Februari", "Mars", "April", "Maj", "Juni", "Juli", "Augusti", "September", "Oktober", "November", "December"
				],
				dayOfWeek: [
					"Sön", "Mån", "Tis", "Ons", "Tor", "Fre", "Lör"
				]
			},
			'zh-TW': { //Traditional Chinese (繁體中文)
				months: [
					"一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"
				],
				dayOfWeek: [
					"日", "一", "二", "三", "四", "五", "六"
				]
			},
			zh: { //Simplified Chinese (简体中文)
				months: [
					"一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"
				],
				dayOfWeek: [
					"日", "一", "二", "三", "四", "五", "六"
				]
			},
			he: { //Hebrew (עברית)
				months: [
					'ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי', 'יוני', 'יולי', 'אוגוסט', 'ספטמבר', 'אוקטובר', 'נובמבר', 'דצמבר'
				],
				dayOfWeek: [
					'א\'', 'ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'שבת'
				]
			},
			hy: { // Armenian
				months: [
					"Հունվար", "Փետրվար", "Մարտ", "Ապրիլ", "Մայիս", "Հունիս", "Հուլիս", "Օգոստոս", "Սեպտեմբեր", "Հոկտեմբեր", "Նոյեմբեր", "Դեկտեմբեր"
				],
				dayOfWeek: [
					"Կի", "Երկ", "Երք", "Չոր", "Հնգ", "Ուրբ", "Շբթ"
				]
			},
            kg: { // Kyrgyz
                months: [
                    'Үчтүн айы', 'Бирдин айы', 'Жалган Куран', 'Чын Куран', 'Бугу', 'Кулжа', 'Теке', 'Баш Оона', 'Аяк Оона', 'Тогуздун айы', 'Жетинин айы', 'Бештин айы'
                ],
                dayOfWeek: [
                    "Жек", "Дүй", "Шей", "Шар", "Бей", "Жум", "Ише"
                ]
            }
		},
		value: '',
		lang: 'en',

		format:	'Y/m/d H:i',
		formatTime:	'H:i',
		formatDate:	'Y/m/d',

		startDate:	false, // new Date(), '1986/12/08', '-1970/01/05','-1970/01/05',
		step: 60,
		monthChangeSpinner: true,

		closeOnDateSelect: false,
		closeOnTimeSelect: true,
		closeOnWithoutClick: true,
		closeOnInputClick: true,

		timepicker: true,
		datepicker: true,
		weeks: false,

		defaultTime: false,	// use formatTime format (ex. '10:00' for formatTime:	'H:i')
		defaultDate: false,	// use formatDate format (ex new Date() or '1986/12/08' or '-1970/01/05' or '-1970/01/05')

		minDate: false,
		maxDate: false,
		minTime: false,
		maxTime: false,
		disabledMinTime: false,
		disabledMaxTime: false,

		allowTimes: [],
		opened: false,
		initTime: true,
		inline: false,
		theme: '',

		onSelectDate: function () {},
		onSelectTime: function () {},
		onChangeMonth: function () {},
		onChangeYear: function () {},
		onChangeDateTime: function () {},
		onShow: function () {},
		onClose: function () {},
		onGenerate: function () {},

		withoutCopyright: true,
		inverseButton: false,
		hours12: false,
		next: 'xdsoft_next',
		prev : 'xdsoft_prev',
		dayOfWeekStart: 0,
		parentID: 'body',
		timeHeightInTimePicker: 25,
		timepickerScrollbar: true,
		todayButton: true,
		prevButton: true,
		nextButton: true,
		defaultSelect: true,

		scrollMonth: true,
		scrollTime: true,
		scrollInput: true,

		lazyInit: false,
		mask: false,
		validateOnBlur: true,
		allowBlank: true,
		yearStart: 1950,
		yearEnd: 2050,
		monthStart: 0,
		monthEnd: 11,
		style: '',
		id: '',
		fixed: false,
		roundTime: 'round', // ceil, floor
		className: '',
		weekends: [],
		highlightedDates: [],
		highlightedPeriods: [],
		disabledDates : [],
		disabledWeekDays: [],
		yearOffset: 0,
		beforeShowDay: null,

		enterLikeTab: true,
        showApplyButton: false
	};
	// fix for ie8
	if (!window.getComputedStyle) {
		window.getComputedStyle = function (el, pseudo) {
			this.el = el;
			this.getPropertyValue = function (prop) {
				var re = /(\-([a-z]){1})/g;
				if (prop === 'float') {
					prop = 'styleFloat';
				}
				if (re.test(prop)) {
					prop = prop.replace(re, function (a, b, c) {
						return c.toUpperCase();
					});
				}
				return el.currentStyle[prop] || null;
			};
			return this;
		};
	}
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function (obj, start) {
			var i, j;
			for (i = (start || 0), j = this.length; i < j; i += 1) {
				if (this[i] === obj) { return i; }
			}
			return -1;
		};
	}
	Date.prototype.countDaysInMonth = function () {
		return new Date(this.getFullYear(), this.getMonth() + 1, 0).getDate();
	};
	$.fn.xdsoftScroller = function (percent) {
		return this.each(function () {
			var timeboxparent = $(this),
				pointerEventToXY = function (e) {
					var out = {x: 0, y: 0},
						touch;
					if (e.type === 'touchstart' || e.type === 'touchmove' || e.type === 'touchend' || e.type === 'touchcancel') {
						touch  = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
						out.x = touch.clientX;
						out.y = touch.clientY;
					} else if (e.type === 'mousedown' || e.type === 'mouseup' || e.type === 'mousemove' || e.type === 'mouseover' || e.type === 'mouseout' || e.type === 'mouseenter' || e.type === 'mouseleave') {
						out.x = e.clientX;
						out.y = e.clientY;
					}
					return out;
				},
				move = 0,
				timebox,
				parentHeight,
				height,
				scrollbar,
				scroller,
				maximumOffset = 100,
				start = false,
				startY = 0,
				startTop = 0,
				h1 = 0,
				touchStart = false,
				startTopScroll = 0,
				calcOffset = function () {};
			if (percent === 'hide') {
				timeboxparent.find('.xdsoft_scrollbar').hide();
				return;
			}
			if (!$(this).hasClass('xdsoft_scroller_box')) {
				timebox = timeboxparent.children().eq(0);
				parentHeight = timeboxparent[0].clientHeight;
				height = timebox[0].offsetHeight;
				scrollbar = $('<div class="xdsoft_scrollbar"></div>');
				scroller = $('<div class="xdsoft_scroller"></div>');
				scrollbar.append(scroller);

				timeboxparent.addClass('xdsoft_scroller_box').append(scrollbar);
				calcOffset = function calcOffset(event) {
					var offset = pointerEventToXY(event).y - startY + startTopScroll;
					if (offset < 0) {
						offset = 0;
					}
					if (offset + scroller[0].offsetHeight > h1) {
						offset = h1 - scroller[0].offsetHeight;
					}
					timeboxparent.trigger('scroll_element.xdsoft_scroller', [maximumOffset ? offset / maximumOffset : 0]);
				};

				scroller
					.on('touchstart.xdsoft_scroller mousedown.xdsoft_scroller', function (event) {
						if (!parentHeight) {
							timeboxparent.trigger('resize_scroll.xdsoft_scroller', [percent]);
						}

						startY = pointerEventToXY(event).y;
						startTopScroll = parseInt(scroller.css('margin-top'), 10);
						h1 = scrollbar[0].offsetHeight;

						if (event.type === 'mousedown') {
							if (document) {
								$(document.body).addClass('xdsoft_noselect');
							}
							$([document.body, window]).on('mouseup.xdsoft_scroller', function arguments_callee() {
								$([document.body, window]).off('mouseup.xdsoft_scroller', arguments_callee)
									.off('mousemove.xdsoft_scroller', calcOffset)
									.removeClass('xdsoft_noselect');
							});
							$(document.body).on('mousemove.xdsoft_scroller', calcOffset);
						} else {
							touchStart = true;
							event.stopPropagation();
							event.preventDefault();
						}
					})
					.on('touchmove', function (event) {
						if (touchStart) {
							event.preventDefault();
							calcOffset(event);
						}
					})
					.on('touchend touchcancel', function (event) {
						touchStart =  false;
						startTopScroll = 0;
					});

				timeboxparent
					.on('scroll_element.xdsoft_scroller', function (event, percentage) {
						if (!parentHeight) {
							timeboxparent.trigger('resize_scroll.xdsoft_scroller', [percentage, true]);
						}
						percentage = percentage > 1 ? 1 : (percentage < 0 || isNaN(percentage)) ? 0 : percentage;

						scroller.css('margin-top', maximumOffset * percentage);

						setTimeout(function () {
							timebox.css('marginTop', -parseInt((timebox[0].offsetHeight - parentHeight) * percentage, 10));
						}, 10);
					})
					.on('resize_scroll.xdsoft_scroller', function (event, percentage, noTriggerScroll) {
						var percent, sh;
						parentHeight = timeboxparent[0].clientHeight;
						height = timebox[0].offsetHeight;
						percent = parentHeight / height;
						sh = percent * scrollbar[0].offsetHeight;
						if (percent > 1) {
							scroller.hide();
						} else {
							scroller.show();
							scroller.css('height', parseInt(sh > 10 ? sh : 10, 10));
							maximumOffset = scrollbar[0].offsetHeight - scroller[0].offsetHeight;
							if (noTriggerScroll !== true) {
								timeboxparent.trigger('scroll_element.xdsoft_scroller', [percentage || Math.abs(parseInt(timebox.css('marginTop'), 10)) / (height - parentHeight)]);
							}
						}
					});

				timeboxparent.on('mousewheel', function (event) {
					var top = Math.abs(parseInt(timebox.css('marginTop'), 10));

					top = top - (event.deltaY * 20);
					if (top < 0) {
						top = 0;
					}

					timeboxparent.trigger('scroll_element.xdsoft_scroller', [top / (height - parentHeight)]);
					event.stopPropagation();
					return false;
				});

				timeboxparent.on('touchstart', function (event) {
					start = pointerEventToXY(event);
					startTop = Math.abs(parseInt(timebox.css('marginTop'), 10));
				});

				timeboxparent.on('touchmove', function (event) {
					if (start) {
						event.preventDefault();
						var coord = pointerEventToXY(event);
						timeboxparent.trigger('scroll_element.xdsoft_scroller', [(startTop - (coord.y - start.y)) / (height - parentHeight)]);
					}
				});

				timeboxparent.on('touchend touchcancel', function (event) {
					start = false;
					startTop = 0;
				});
			}
			timeboxparent.trigger('resize_scroll.xdsoft_scroller', [percent]);
		});
	};

	$.fn.datetimepicker = function (opt) {
		var KEY0 = 48,
			KEY9 = 57,
			_KEY0 = 96,
			_KEY9 = 105,
			CTRLKEY = 17,
			DEL = 46,
			ENTER = 13,
			ESC = 27,
			BACKSPACE = 8,
			ARROWLEFT = 37,
			ARROWUP = 38,
			ARROWRIGHT = 39,
			ARROWDOWN = 40,
			TAB = 9,
			F5 = 116,
			AKEY = 65,
			CKEY = 67,
			VKEY = 86,
			ZKEY = 90,
			YKEY = 89,
			ctrlDown	=	false,
			options = ($.isPlainObject(opt) || !opt) ? $.extend(true, {}, default_options, opt) : $.extend(true, {}, default_options),

			lazyInitTimer = 0,
			createDateTimePicker,
			destroyDateTimePicker,

			lazyInit = function (input) {
				input
					.on('open.xdsoft focusin.xdsoft mousedown.xdsoft', function initOnActionCallback(event) {
						if (input.is(':disabled') || input.data('xdsoft_datetimepicker')) {
							return;
						}
						clearTimeout(lazyInitTimer);
						lazyInitTimer = setTimeout(function () {

							if (!input.data('xdsoft_datetimepicker')) {
								createDateTimePicker(input);
							}
							input
								.off('open.xdsoft focusin.xdsoft mousedown.xdsoft', initOnActionCallback)
								.trigger('open.xdsoft');
						}, 100);
					});
			};

		createDateTimePicker = function (input) {
			var datetimepicker = $('<div class="xdsoft_datetimepicker xdsoft_noselect"></div>'),
				xdsoft_copyright = $('<div class="xdsoft_copyright"><a target="_blank" href="http://xdsoft.net/jqplugins/datetimepicker/">xdsoft.net</a></div>'),
				datepicker = $('<div class="xdsoft_datepicker active"></div>'),
				mounth_picker = $('<div class="xdsoft_mounthpicker"><button type="button" class="xdsoft_prev"></button><button type="button" class="xdsoft_today_button"></button>' +
					'<div class="xdsoft_label xdsoft_month"><span></span><i></i></div>' +
					'<div class="xdsoft_label xdsoft_year"><span></span><i></i></div>' +
					'<button type="button" class="xdsoft_next"></button></div>'),
				calendar = $('<div class="xdsoft_calendar"></div>'),
				timepicker = $('<div class="xdsoft_timepicker active"><button type="button" class="xdsoft_prev"></button><div class="xdsoft_time_box"></div><button type="button" class="xdsoft_next"></button></div>'),
				timeboxparent = timepicker.find('.xdsoft_time_box').eq(0),
				timebox = $('<div class="xdsoft_time_variant"></div>'),
                applyButton = $('<button type="button" class="xdsoft_save_selected blue-gradient-button">Save Selected</button>'),
				/*scrollbar = $('<div class="xdsoft_scrollbar"></div>'),
				scroller = $('<div class="xdsoft_scroller"></div>'),*/
				monthselect = $('<div class="xdsoft_select xdsoft_monthselect"><div></div></div>'),
				yearselect = $('<div class="xdsoft_select xdsoft_yearselect"><div></div></div>'),
				triggerAfterOpen = false,
				XDSoft_datetime,
				//scroll_element,
				xchangeTimer,
				timerclick,
				current_time_index,
				setPos,
				timer = 0,
				timer1 = 0,
				_xdsoft_datetime;

			if (options.id) {
				datetimepicker.attr('id', options.id);
			}
			if (options.style) {
				datetimepicker.attr('style', options.style);
			}
			if (options.weeks) {
				datetimepicker.addClass('xdsoft_showweeks');
			}

			datetimepicker.addClass('xdsoft_' + options.theme);
			datetimepicker.addClass(options.className);

			mounth_picker
				.find('.xdsoft_month span')
					.after(monthselect);
			mounth_picker
				.find('.xdsoft_year span')
					.after(yearselect);

			mounth_picker
				.find('.xdsoft_month,.xdsoft_year')
					.on('mousedown.xdsoft', function (event) {
					var select = $(this).find('.xdsoft_select').eq(0),
						val = 0,
						top = 0,
						visible = select.is(':visible'),
						items,
						i;

					mounth_picker
						.find('.xdsoft_select')
							.hide();
					if (_xdsoft_datetime.currentTime) {
						val = _xdsoft_datetime.currentTime[$(this).hasClass('xdsoft_month') ? 'getMonth' : 'getFullYear']();
					}

					select[visible ? 'hide' : 'show']();
					for (items = select.find('div.xdsoft_option'), i = 0; i < items.length; i += 1) {
						if (items.eq(i).data('value') === val) {
							break;
						} else {
							top += items[0].offsetHeight;
						}
					}

					select.xdsoftScroller(top / (select.children()[0].offsetHeight - (select[0].clientHeight)));
					event.stopPropagation();
					return false;
				});

			mounth_picker
				.find('.xdsoft_select')
					.xdsoftScroller()
				.on('mousedown.xdsoft', function (event) {
					event.stopPropagation();
					event.preventDefault();
				})
				.on('mousedown.xdsoft', '.xdsoft_option', function (event) {

					if (_xdsoft_datetime.currentTime === undefined || _xdsoft_datetime.currentTime === null) {
						_xdsoft_datetime.currentTime = _xdsoft_datetime.now();
					}

					var year = _xdsoft_datetime.currentTime.getFullYear();
					if (_xdsoft_datetime && _xdsoft_datetime.currentTime) {
						_xdsoft_datetime.currentTime[$(this).parent().parent().hasClass('xdsoft_monthselect') ? 'setMonth' : 'setFullYear']($(this).data('value'));
					}

					$(this).parent().parent().hide();

					datetimepicker.trigger('xchange.xdsoft');
					if (options.onChangeMonth && $.isFunction(options.onChangeMonth)) {
						options.onChangeMonth.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'));
					}

					if (year !== _xdsoft_datetime.currentTime.getFullYear() && $.isFunction(options.onChangeYear)) {
						options.onChangeYear.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'));
					}
				});

			datetimepicker.setOptions = function (_options) {
				var highlightedDates = {},
					getCaretPos = function (input) {
						try {
							if (document.selection && document.selection.createRange) {
								var range = document.selection.createRange();
								return range.getBookmark().charCodeAt(2) - 2;
							}
							if (input.setSelectionRange) {
								return input.selectionStart;
							}
						} catch (e) {
							return 0;
						}
					},
					setCaretPos = function (node, pos) {
						node = (typeof node === "string" || node instanceof String) ? document.getElementById(node) : node;
						if (!node) {
							return false;
						}
						if (node.createTextRange) {
							var textRange = node.createTextRange();
							textRange.collapse(true);
							textRange.moveEnd('character', pos);
							textRange.moveStart('character', pos);
							textRange.select();
							return true;
						}
						if (node.setSelectionRange) {
							node.setSelectionRange(pos, pos);
							return true;
						}
						return false;
					},
					isValidValue = function (mask, value) {
						var reg = mask
							.replace(/([\[\]\/\{\}\(\)\-\.\+]{1})/g, '\\$1')
							.replace(/_/g, '{digit+}')
							.replace(/([0-9]{1})/g, '{digit$1}')
							.replace(/\{digit([0-9]{1})\}/g, '[0-$1_]{1}')
							.replace(/\{digit[\+]\}/g, '[0-9_]{1}');
						return (new RegExp(reg)).test(value);
					};
				options = $.extend(true, {}, options, _options);

				if (_options.allowTimes && $.isArray(_options.allowTimes) && _options.allowTimes.length) {
					options.allowTimes = $.extend(true, [], _options.allowTimes);
				}

				if (_options.weekends && $.isArray(_options.weekends) && _options.weekends.length) {
					options.weekends = $.extend(true, [], _options.weekends);
				}

				if (_options.highlightedDates && $.isArray(_options.highlightedDates) && _options.highlightedDates.length) {
					$.each(_options.highlightedDates, function (index, value) {
						var splitData = $.map(value.split(','), $.trim),
							exDesc,
							hDate = new HighlightedDate(Date.parseDate(splitData[0], options.formatDate), splitData[1], splitData[2]), // date, desc, style
							keyDate = hDate.date.dateFormat(options.formatDate);
						if (highlightedDates[keyDate] !== undefined) {
							exDesc = highlightedDates[keyDate].desc;
							if (exDesc && exDesc.length && hDate.desc && hDate.desc.length) {
								highlightedDates[keyDate].desc = exDesc + "\n" + hDate.desc;
							}
						} else {
							highlightedDates[keyDate] = hDate;
						}
					});

					options.highlightedDates = $.extend(true, [], highlightedDates);
				}

				if (_options.highlightedPeriods && $.isArray(_options.highlightedPeriods) && _options.highlightedPeriods.length) {
					highlightedDates = $.extend(true, [], options.highlightedDates);
					$.each(_options.highlightedPeriods, function (index, value) {
						var splitData = $.map(value.split(','), $.trim),
							dateTest = Date.parseDate(splitData[0], options.formatDate), // start date
							dateEnd = Date.parseDate(splitData[1], options.formatDate),
							desc = splitData[2],
							hDate,
							keyDate,
							exDesc,
							style = splitData[3];

						while (dateTest <= dateEnd) {
							hDate = new HighlightedDate(dateTest, desc, style);
							keyDate = dateTest.dateFormat(options.formatDate);
							dateTest.setDate(dateTest.getDate() + 1);
							if (highlightedDates[keyDate] !== undefined) {
								exDesc = highlightedDates[keyDate].desc;
								if (exDesc && exDesc.length && hDate.desc && hDate.desc.length) {
									highlightedDates[keyDate].desc = exDesc + "\n" + hDate.desc;
								}
							} else {
								highlightedDates[keyDate] = hDate;
							}
						}
					});

					options.highlightedDates = $.extend(true, [], highlightedDates);
				}

				if (_options.disabledDates && $.isArray(_options.disabledDates) && _options.disabledDates.length) {
					options.disabledDates = $.extend(true, [], _options.disabledDates);
				}

				if (_options.disabledWeekDays && $.isArray(_options.disabledWeekDays) && _options.disabledWeekDays.length) {
				    options.disabledWeekDays = $.extend(true, [], _options.disabledWeekDays);
				}

				if ((options.open || options.opened) && (!options.inline)) {
					input.trigger('open.xdsoft');
				}

				if (options.inline) {
					triggerAfterOpen = true;
					datetimepicker.addClass('xdsoft_inline');
					input.after(datetimepicker).hide();
				}

				if (options.inverseButton) {
					options.next = 'xdsoft_prev';
					options.prev = 'xdsoft_next';
				}

				if (options.datepicker) {
					datepicker.addClass('active');
				} else {
					datepicker.removeClass('active');
				}

				if (options.timepicker) {
					timepicker.addClass('active');
				} else {
					timepicker.removeClass('active');
				}

				if (options.value) {
					_xdsoft_datetime.setCurrentTime(options.value);
					if (input && input.val) {
						input.val(_xdsoft_datetime.str);
					}
				}

				if (isNaN(options.dayOfWeekStart)) {
					options.dayOfWeekStart = 0;
				} else {
					options.dayOfWeekStart = parseInt(options.dayOfWeekStart, 10) % 7;
				}

				if (!options.timepickerScrollbar) {
					timeboxparent.xdsoftScroller('hide');
				}

				if (options.minDate && /^-(.*)$/.test(options.minDate)) {
					options.minDate = _xdsoft_datetime.strToDateTime(options.minDate).dateFormat(options.formatDate);
				}

				if (options.maxDate &&  /^\+(.*)$/.test(options.maxDate)) {
					options.maxDate = _xdsoft_datetime.strToDateTime(options.maxDate).dateFormat(options.formatDate);
				}

				applyButton.toggle(options.showApplyButton);

				mounth_picker
					.find('.xdsoft_today_button')
						.css('visibility', !options.todayButton ? 'hidden' : 'visible');

				mounth_picker
					.find('.' + options.prev)
						.css('visibility', !options.prevButton ? 'hidden' : 'visible');

				mounth_picker
					.find('.' + options.next)
						.css('visibility', !options.nextButton ? 'hidden' : 'visible');

				if (options.mask) {
					input.off('keydown.xdsoft');

					if (options.mask === true) {
						options.mask = options.format
							.replace(/Y/g, '9999')
							.replace(/F/g, '9999')
							.replace(/m/g, '19')
							.replace(/d/g, '39')
							.replace(/H/g, '29')
							.replace(/i/g, '59')
							.replace(/s/g, '59');
					}

					if ($.type(options.mask) === 'string') {
						if (!isValidValue(options.mask, input.val())) {
							input.val(options.mask.replace(/[0-9]/g, '_'));
						}

						input.on('keydown.xdsoft', function (event) {
							var val = this.value,
								key = event.which,
								pos,
								digit;

							if (((key >= KEY0 && key <= KEY9) || (key >= _KEY0 && key <= _KEY9)) || (key === BACKSPACE || key === DEL)) {
								pos = getCaretPos(this);
								digit = (key !== BACKSPACE && key !== DEL) ? String.fromCharCode((_KEY0 <= key && key <= _KEY9) ? key - KEY0 : key) : '_';

								if ((key === BACKSPACE || key === DEL) && pos) {
									pos -= 1;
									digit = '_';
								}

								while (/[^0-9_]/.test(options.mask.substr(pos, 1)) && pos < options.mask.length && pos > 0) {
									pos += (key === BACKSPACE || key === DEL) ? -1 : 1;
								}

								val = val.substr(0, pos) + digit + val.substr(pos + 1);
								if ($.trim(val) === '') {
									val = options.mask.replace(/[0-9]/g, '_');
								} else {
									if (pos === options.mask.length) {
										event.preventDefault();
										return false;
									}
								}

								pos += (key === BACKSPACE || key === DEL) ? 0 : 1;
								while (/[^0-9_]/.test(options.mask.substr(pos, 1)) && pos < options.mask.length && pos > 0) {
									pos += (key === BACKSPACE || key === DEL) ? -1 : 1;
								}

								if (isValidValue(options.mask, val)) {
									this.value = val;
									setCaretPos(this, pos);
								} else if ($.trim(val) === '') {
									this.value = options.mask.replace(/[0-9]/g, '_');
								} else {
									input.trigger('error_input.xdsoft');
								}
							} else {
								if (([AKEY, CKEY, VKEY, ZKEY, YKEY].indexOf(key) !== -1 && ctrlDown) || [ESC, ARROWUP, ARROWDOWN, ARROWLEFT, ARROWRIGHT, F5, CTRLKEY, TAB, ENTER].indexOf(key) !== -1) {
									return true;
								}
							}

							event.preventDefault();
							return false;
						});
					}
				}
				if (options.validateOnBlur) {
					input
						.off('blur.xdsoft')
						.on('blur.xdsoft', function () {
							if (options.allowBlank && !$.trim($(this).val()).length) {
								$(this).val(null);
								datetimepicker.data('xdsoft_datetime').empty();
							} else if (!Date.parseDate($(this).val(), options.format)) {
								var splittedHours   = +([$(this).val()[0], $(this).val()[1]].join('')),
									splittedMinutes = +([$(this).val()[2], $(this).val()[3]].join(''));

								// parse the numbers as 0312 => 03:12
								if (!options.datepicker && options.timepicker && splittedHours >= 0 && splittedHours < 24 && splittedMinutes >= 0 && splittedMinutes < 60) {
									$(this).val([splittedHours, splittedMinutes].map(function (item) {
										return item > 9 ? item : '0' + item;
									}).join(':'));
								} else {
									$(this).val((_xdsoft_datetime.now()).dateFormat(options.format));
								}

								datetimepicker.data('xdsoft_datetime').setCurrentTime($(this).val());
							} else {
								datetimepicker.data('xdsoft_datetime').setCurrentTime($(this).val());
							}

							datetimepicker.trigger('changedatetime.xdsoft');
						});
				}
				options.dayOfWeekStartPrev = (options.dayOfWeekStart === 0) ? 6 : options.dayOfWeekStart - 1;

				datetimepicker
					.trigger('xchange.xdsoft')
					.trigger('afterOpen.xdsoft');
			};

			datetimepicker
				.data('options', options)
				.on('mousedown.xdsoft', function (event) {
					event.stopPropagation();
					event.preventDefault();
					yearselect.hide();
					monthselect.hide();
					return false;
				});

			//scroll_element = timepicker.find('.xdsoft_time_box');
			timeboxparent.append(timebox);
			timeboxparent.xdsoftScroller();

			datetimepicker.on('afterOpen.xdsoft', function () {
				timeboxparent.xdsoftScroller();
			});

			datetimepicker
				.append(datepicker)
				.append(timepicker);

			if (options.withoutCopyright !== true) {
				datetimepicker
					.append(xdsoft_copyright);
			}

			datepicker
				.append(mounth_picker)
				.append(calendar)
				.append(applyButton);

			$(options.parentID)
				.append(datetimepicker);

			XDSoft_datetime = function () {
				var _this = this;
				_this.now = function (norecursion) {
					var d = new Date(),
						date,
						time;

					if (!norecursion && options.defaultDate) {
						date = _this.strToDateTime(options.defaultDate);
						d.setFullYear(date.getFullYear());
						d.setMonth(date.getMonth());
						d.setDate(date.getDate());
					}

					if (options.yearOffset) {
						d.setFullYear(d.getFullYear() + options.yearOffset);
					}

					if (!norecursion && options.defaultTime) {
						time = _this.strtotime(options.defaultTime);
						d.setHours(time.getHours());
						d.setMinutes(time.getMinutes());
					}
					return d;
				};

				_this.isValidDate = function (d) {
					if (Object.prototype.toString.call(d) !== "[object Date]") {
						return false;
					}
					return !isNaN(d.getTime());
				};

				_this.setCurrentTime = function (dTime) {
					_this.currentTime = (typeof dTime === 'string') ? _this.strToDateTime(dTime) : _this.isValidDate(dTime) ? dTime : _this.now();
					datetimepicker.trigger('xchange.xdsoft');
				};

				_this.empty = function () {
					_this.currentTime = null;
				};

				_this.getCurrentTime = function (dTime) {
					return _this.currentTime;
				};

				_this.nextMonth = function () {

					if (_this.currentTime === undefined || _this.currentTime === null) {
						_this.currentTime = _this.now();
					}

					var month = _this.currentTime.getMonth() + 1,
						year;
					if (month === 12) {
						_this.currentTime.setFullYear(_this.currentTime.getFullYear() + 1);
						month = 0;
					}

					year = _this.currentTime.getFullYear();

					_this.currentTime.setDate(
						Math.min(
							new Date(_this.currentTime.getFullYear(), month + 1, 0).getDate(),
							_this.currentTime.getDate()
						)
					);
					_this.currentTime.setMonth(month);

					if (options.onChangeMonth && $.isFunction(options.onChangeMonth)) {
						options.onChangeMonth.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'));
					}

					if (year !== _this.currentTime.getFullYear() && $.isFunction(options.onChangeYear)) {
						options.onChangeYear.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'));
					}

					datetimepicker.trigger('xchange.xdsoft');
					return month;
				};

				_this.prevMonth = function () {

					if (_this.currentTime === undefined || _this.currentTime === null) {
						_this.currentTime = _this.now();
					}

					var month = _this.currentTime.getMonth() - 1;
					if (month === -1) {
						_this.currentTime.setFullYear(_this.currentTime.getFullYear() - 1);
						month = 11;
					}
					_this.currentTime.setDate(
						Math.min(
							new Date(_this.currentTime.getFullYear(), month + 1, 0).getDate(),
							_this.currentTime.getDate()
						)
					);
					_this.currentTime.setMonth(month);
					if (options.onChangeMonth && $.isFunction(options.onChangeMonth)) {
						options.onChangeMonth.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'));
					}
					datetimepicker.trigger('xchange.xdsoft');
					return month;
				};

				_this.getWeekOfYear = function (datetime) {
					var onejan = new Date(datetime.getFullYear(), 0, 1);
					return Math.ceil((((datetime - onejan) / 86400000) + onejan.getDay() + 1) / 7);
				};

				_this.strToDateTime = function (sDateTime) {
					var tmpDate = [], timeOffset, currentTime;

					if (sDateTime && sDateTime instanceof Date && _this.isValidDate(sDateTime)) {
						return sDateTime;
					}

					tmpDate = /^(\+|\-)(.*)$/.exec(sDateTime);
					if (tmpDate) {
						tmpDate[2] = Date.parseDate(tmpDate[2], options.formatDate);
					}
					if (tmpDate  && tmpDate[2]) {
						timeOffset = tmpDate[2].getTime() - (tmpDate[2].getTimezoneOffset()) * 60000;
						currentTime = new Date((_this.now(true)).getTime() + parseInt(tmpDate[1] + '1', 10) * timeOffset);
					} else {
						currentTime = sDateTime ? Date.parseDate(sDateTime, options.format) : _this.now();
					}

					if (!_this.isValidDate(currentTime)) {
						currentTime = _this.now();
					}

					return currentTime;
				};

				_this.strToDate = function (sDate) {
					if (sDate && sDate instanceof Date && _this.isValidDate(sDate)) {
						return sDate;
					}

					var currentTime = sDate ? Date.parseDate(sDate, options.formatDate) : _this.now(true);
					if (!_this.isValidDate(currentTime)) {
						currentTime = _this.now(true);
					}
					return currentTime;
				};

				_this.strtotime = function (sTime) {
					if (sTime && sTime instanceof Date && _this.isValidDate(sTime)) {
						return sTime;
					}
					var currentTime = sTime ? Date.parseDate(sTime, options.formatTime) : _this.now(true);
					if (!_this.isValidDate(currentTime)) {
						currentTime = _this.now(true);
					}
					return currentTime;
				};

				_this.str = function () {
					return _this.currentTime.dateFormat(options.format);
				};
				_this.currentTime = this.now();
			};

			_xdsoft_datetime = new XDSoft_datetime();

			applyButton.on('click', function (e) {//pathbrite
                e.preventDefault();
                datetimepicker.data('changed', true);
                _xdsoft_datetime.setCurrentTime(getCurrentValue());
                input.val(_xdsoft_datetime.str());
                datetimepicker.trigger('close.xdsoft');
            });
			mounth_picker
				.find('.xdsoft_today_button')
				.on('mousedown.xdsoft', function () {
					datetimepicker.data('changed', true);
					_xdsoft_datetime.setCurrentTime(0);
					datetimepicker.trigger('afterOpen.xdsoft');
				}).on('dblclick.xdsoft', function () {
					var currentDate = _xdsoft_datetime.getCurrentTime(), minDate, maxDate;
					currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate());
					minDate = _xdsoft_datetime.strToDate(options.minDate);
					minDate = new Date(minDate.getFullYear(), minDate.getMonth(), minDate.getDate());
					if (currentDate < minDate) {
						return;
					}
					maxDate = _xdsoft_datetime.strToDate(options.maxDate);
					maxDate = new Date(maxDate.getFullYear(), maxDate.getMonth(), maxDate.getDate());
					if (currentDate > maxDate) {
						return;
					}
					input.val(_xdsoft_datetime.str());
					datetimepicker.trigger('close.xdsoft');
				});
			mounth_picker
				.find('.xdsoft_prev,.xdsoft_next')
				.on('mousedown.xdsoft', function () {
					var $this = $(this),
						timer = 0,
						stop = false;

					(function arguments_callee1(v) {
						if ($this.hasClass(options.next)) {
							_xdsoft_datetime.nextMonth();
						} else if ($this.hasClass(options.prev)) {
							_xdsoft_datetime.prevMonth();
						}
						if (options.monthChangeSpinner) {
							if (!stop) {
								timer = setTimeout(arguments_callee1, v || 100);
							}
						}
					}(500));

					$([document.body, window]).on('mouseup.xdsoft', function arguments_callee2() {
						clearTimeout(timer);
						stop = true;
						$([document.body, window]).off('mouseup.xdsoft', arguments_callee2);
					});
				});

			timepicker
				.find('.xdsoft_prev,.xdsoft_next')
				.on('mousedown.xdsoft', function () {
					var $this = $(this),
						timer = 0,
						stop = false,
						period = 110;
					(function arguments_callee4(v) {
						var pheight = timeboxparent[0].clientHeight,
							height = timebox[0].offsetHeight,
							top = Math.abs(parseInt(timebox.css('marginTop'), 10));
						if ($this.hasClass(options.next) && (height - pheight) - options.timeHeightInTimePicker >= top) {
							timebox.css('marginTop', '-' + (top + options.timeHeightInTimePicker) + 'px');
						} else if ($this.hasClass(options.prev) && top - options.timeHeightInTimePicker >= 0) {
							timebox.css('marginTop', '-' + (top - options.timeHeightInTimePicker) + 'px');
						}
						timeboxparent.trigger('scroll_element.xdsoft_scroller', [Math.abs(parseInt(timebox.css('marginTop'), 10) / (height - pheight))]);
						period = (period > 10) ? 10 : period - 10;
						if (!stop) {
							timer = setTimeout(arguments_callee4, v || period);
						}
					}(500));
					$([document.body, window]).on('mouseup.xdsoft', function arguments_callee5() {
						clearTimeout(timer);
						stop = true;
						$([document.body, window])
							.off('mouseup.xdsoft', arguments_callee5);
					});
				});

			xchangeTimer = 0;
			// base handler - generating a calendar and timepicker
			datetimepicker
				.on('xchange.xdsoft', function (event) {
					clearTimeout(xchangeTimer);
					xchangeTimer = setTimeout(function () {

						if (_xdsoft_datetime.currentTime === undefined || _xdsoft_datetime.currentTime === null) {
							_xdsoft_datetime.currentTime = _xdsoft_datetime.now();
						}

						var table =	'',
							start = new Date(_xdsoft_datetime.currentTime.getFullYear(), _xdsoft_datetime.currentTime.getMonth(), 1, 12, 0, 0),
							i = 0,
							j,
							today = _xdsoft_datetime.now(),
							maxDate = false,
							minDate = false,
							hDate,
							day,
							d,
							y,
							m,
							w,
							classes = [],
							customDateSettings,
							newRow = true,
							time = '',
							h = '',
							line_time,
							description;

						while (start.getDay() !== options.dayOfWeekStart) {
							start.setDate(start.getDate() - 1);
						}

						table += '<table><thead><tr>';

						if (options.weeks) {
							table += '<th></th>';
						}

						for (j = 0; j < 7; j += 1) {
							table += '<th>' + options.i18n[options.lang].dayOfWeek[(j + options.dayOfWeekStart) % 7] + '</th>';
						}

						table += '</tr></thead>';
						table += '<tbody>';

						if (options.maxDate !== false) {
							maxDate = _xdsoft_datetime.strToDate(options.maxDate);
							maxDate = new Date(maxDate.getFullYear(), maxDate.getMonth(), maxDate.getDate(), 23, 59, 59, 999);
						}

						if (options.minDate !== false) {
							minDate = _xdsoft_datetime.strToDate(options.minDate);
							minDate = new Date(minDate.getFullYear(), minDate.getMonth(), minDate.getDate());
						}

						while (i < _xdsoft_datetime.currentTime.countDaysInMonth() || start.getDay() !== options.dayOfWeekStart || _xdsoft_datetime.currentTime.getMonth() === start.getMonth()) {
							classes = [];
							i += 1;

							day = start.getDay();
							d = start.getDate();
							y = start.getFullYear();
							m = start.getMonth();
							w = _xdsoft_datetime.getWeekOfYear(start);
							description = '';

							classes.push('xdsoft_date');

							if (options.beforeShowDay && $.isFunction(options.beforeShowDay.call)) {
								customDateSettings = options.beforeShowDay.call(datetimepicker, start);
							} else {
								customDateSettings = null;
							}

							if ((maxDate !== false && start > maxDate) || (minDate !== false && start < minDate) || (customDateSettings && customDateSettings[0] === false)) {
								classes.push('xdsoft_disabled');
							} else if (options.disabledDates.indexOf(start.dateFormat(options.formatDate)) !== -1) {
								classes.push('xdsoft_disabled');
							} else if (options.disabledWeekDays.indexOf(day) !== -1) {
							    classes.push('xdsoft_disabled');
							}

							if (customDateSettings && customDateSettings[1] !== "") {
								classes.push(customDateSettings[1]);
							}

							if (_xdsoft_datetime.currentTime.getMonth() !== m) {
								classes.push('xdsoft_other_month');
							}

							if ((options.defaultSelect || datetimepicker.data('changed')) && _xdsoft_datetime.currentTime.dateFormat(options.formatDate) === start.dateFormat(options.formatDate)) {
								classes.push('xdsoft_current');
							}

							if (today.dateFormat(options.formatDate) === start.dateFormat(options.formatDate)) {
								classes.push('xdsoft_today');
							}

							if (start.getDay() === 0 || start.getDay() === 6 || options.weekends.indexOf(start.dateFormat(options.formatDate)) !== -1) {
								classes.push('xdsoft_weekend');
							}

							if (options.highlightedDates[start.dateFormat(options.formatDate)] !== undefined) {
								hDate = options.highlightedDates[start.dateFormat(options.formatDate)];
								classes.push(hDate.style === undefined ? 'xdsoft_highlighted_default' : hDate.style);
								description = hDate.desc === undefined ? '' : hDate.desc;
							}

							if (options.beforeShowDay && $.isFunction(options.beforeShowDay)) {
								classes.push(options.beforeShowDay(start));
							}

							if (newRow) {
								table += '<tr>';
								newRow = false;
								if (options.weeks) {
									table += '<th>' + w + '</th>';
								}
							}

							table += '<td data-date="' + d + '" data-month="' + m + '" data-year="' + y + '"' + ' class="xdsoft_date xdsoft_day_of_week' + start.getDay() + ' ' + classes.join(' ') + '" title="' + description + '">' +
										'<div>' + d + '</div>' +
									'</td>';

							if (start.getDay() === options.dayOfWeekStartPrev) {
								table += '</tr>';
								newRow = true;
							}

							start.setDate(d + 1);
						}
						table += '</tbody></table>';

						calendar.html(table);

						mounth_picker.find('.xdsoft_label span').eq(0).text(options.i18n[options.lang].months[_xdsoft_datetime.currentTime.getMonth()]);
						mounth_picker.find('.xdsoft_label span').eq(1).text(_xdsoft_datetime.currentTime.getFullYear());

						// generate timebox
						time = '';
						h = '';
						m = '';
						line_time = function line_time(h, m) {
							var now = _xdsoft_datetime.now(), optionDateTime, current_time;
							now.setHours(h);
							h = parseInt(now.getHours(), 10);
							now.setMinutes(m);
							m = parseInt(now.getMinutes(), 10);
							optionDateTime = new Date(_xdsoft_datetime.currentTime);
							optionDateTime.setHours(h);
							optionDateTime.setMinutes(m);
							classes = [];
							if ((options.minDateTime !== false && options.minDateTime > optionDateTime) || (options.maxTime !== false && _xdsoft_datetime.strtotime(options.maxTime).getTime() < now.getTime()) || (options.minTime !== false && _xdsoft_datetime.strtotime(options.minTime).getTime() > now.getTime())) {
								classes.push('xdsoft_disabled');
							}
							if ((options.minDateTime !== false && options.minDateTime > optionDateTime) || ((options.disabledMinTime !== false && now.getTime() > _xdsoft_datetime.strtotime(options.disabledMinTime).getTime()) && (options.disabledMaxTime !== false && now.getTime() < _xdsoft_datetime.strtotime(options.disabledMaxTime).getTime()))) {
								classes.push('xdsoft_disabled');
							}

							current_time = new Date(_xdsoft_datetime.currentTime);
							current_time.setHours(parseInt(_xdsoft_datetime.currentTime.getHours(), 10));
							current_time.setMinutes(Math[options.roundTime](_xdsoft_datetime.currentTime.getMinutes() / options.step) * options.step);

							if ((options.initTime || options.defaultSelect || datetimepicker.data('changed')) && current_time.getHours() === parseInt(h, 10) && (options.step > 59 || current_time.getMinutes() === parseInt(m, 10))) {
								if (options.defaultSelect || datetimepicker.data('changed')) {
									classes.push('xdsoft_current');
								} else if (options.initTime) {
									classes.push('xdsoft_init_time');
								}
							}
							if (parseInt(today.getHours(), 10) === parseInt(h, 10) && parseInt(today.getMinutes(), 10) === parseInt(m, 10)) {
								classes.push('xdsoft_today');
							}
							time += '<div class="xdsoft_time ' + classes.join(' ') + '" data-hour="' + h + '" data-minute="' + m + '">' + now.dateFormat(options.formatTime) + '</div>';
						};

						if (!options.allowTimes || !$.isArray(options.allowTimes) || !options.allowTimes.length) {
							for (i = 0, j = 0; i < (options.hours12 ? 12 : 24); i += 1) {
								for (j = 0; j < 60; j += options.step) {
									h = (i < 10 ? '0' : '') + i;
									m = (j < 10 ? '0' : '') + j;
									line_time(h, m);
								}
							}
						} else {
							for (i = 0; i < options.allowTimes.length; i += 1) {
								h = _xdsoft_datetime.strtotime(options.allowTimes[i]).getHours();
								m = _xdsoft_datetime.strtotime(options.allowTimes[i]).getMinutes();
								line_time(h, m);
							}
						}

						timebox.html(time);

						opt = '';
						i = 0;

						for (i = parseInt(options.yearStart, 10) + options.yearOffset; i <= parseInt(options.yearEnd, 10) + options.yearOffset; i += 1) {
							opt += '<div class="xdsoft_option ' + (_xdsoft_datetime.currentTime.getFullYear() === i ? 'xdsoft_current' : '') + '" data-value="' + i + '">' + i + '</div>';
						}
						yearselect.children().eq(0)
												.html(opt);

						for (i = parseInt(options.monthStart, 10), opt = ''; i <= parseInt(options.monthEnd, 10); i += 1) {
							opt += '<div class="xdsoft_option ' + (_xdsoft_datetime.currentTime.getMonth() === i ? 'xdsoft_current' : '') + '" data-value="' + i + '">' + options.i18n[options.lang].months[i] + '</div>';
						}
						monthselect.children().eq(0).html(opt);
						$(datetimepicker)
							.trigger('generate.xdsoft');
					}, 10);
					event.stopPropagation();
				})
				.on('afterOpen.xdsoft', function () {
					if (options.timepicker) {
						var classType, pheight, height, top;
						if (timebox.find('.xdsoft_current').length) {
							classType = '.xdsoft_current';
						} else if (timebox.find('.xdsoft_init_time').length) {
							classType = '.xdsoft_init_time';
						}
						if (classType) {
							pheight = timeboxparent[0].clientHeight;
							height = timebox[0].offsetHeight;
							top = timebox.find(classType).index() * options.timeHeightInTimePicker + 1;
							if ((height - pheight) < top) {
								top = height - pheight;
							}
							timeboxparent.trigger('scroll_element.xdsoft_scroller', [parseInt(top, 10) / (height - pheight)]);
						} else {
							timeboxparent.trigger('scroll_element.xdsoft_scroller', [0]);
						}
					}
				});

			timerclick = 0;
			calendar
				.on('click.xdsoft', 'td', function (xdevent) {
					xdevent.stopPropagation();  // Prevents closing of Pop-ups, Modals and Flyouts in Bootstrap
					timerclick += 1;
					var $this = $(this),
						currentTime = _xdsoft_datetime.currentTime;

					if (currentTime === undefined || currentTime === null) {
						_xdsoft_datetime.currentTime = _xdsoft_datetime.now();
						currentTime = _xdsoft_datetime.currentTime;
					}

					if ($this.hasClass('xdsoft_disabled')) {
						return false;
					}

					currentTime.setDate(1);
					currentTime.setFullYear($this.data('year'));
					currentTime.setMonth($this.data('month'));
					currentTime.setDate($this.data('date'));

					datetimepicker.trigger('select.xdsoft', [currentTime]);

					input.val(_xdsoft_datetime.str());
					if ((timerclick > 1 || (options.closeOnDateSelect === true || (options.closeOnDateSelect === false && !options.timepicker))) && !options.inline) {
						datetimepicker.trigger('close.xdsoft');
					}

					if (options.onSelectDate &&	$.isFunction(options.onSelectDate)) {
						options.onSelectDate.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'), xdevent);
					}

					datetimepicker.data('changed', true);
					datetimepicker.trigger('xchange.xdsoft');
					datetimepicker.trigger('changedatetime.xdsoft');
					setTimeout(function () {
						timerclick = 0;
					}, 200);
				});

			timebox
				.on('click.xdsoft', 'div', function (xdevent) {
					xdevent.stopPropagation();
					var $this = $(this),
						currentTime = _xdsoft_datetime.currentTime;

					if (currentTime === undefined || currentTime === null) {
						_xdsoft_datetime.currentTime = _xdsoft_datetime.now();
						currentTime = _xdsoft_datetime.currentTime;
					}

					if ($this.hasClass('xdsoft_disabled')) {
						return false;
					}
					currentTime.setHours($this.data('hour'));
					currentTime.setMinutes($this.data('minute'));
					datetimepicker.trigger('select.xdsoft', [currentTime]);

					datetimepicker.data('input').val(_xdsoft_datetime.str());

                    if (options.inline !== true && options.closeOnTimeSelect === true) {
                        datetimepicker.trigger('close.xdsoft');
                    }

					if (options.onSelectTime && $.isFunction(options.onSelectTime)) {
						options.onSelectTime.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'), xdevent);
					}
					datetimepicker.data('changed', true);
					datetimepicker.trigger('xchange.xdsoft');
					datetimepicker.trigger('changedatetime.xdsoft');
				});


			datepicker
				.on('mousewheel.xdsoft', function (event) {
					if (!options.scrollMonth) {
						return true;
					}
					if (event.deltaY < 0) {
						_xdsoft_datetime.nextMonth();
					} else {
						_xdsoft_datetime.prevMonth();
					}
					return false;
				});

			input
				.on('mousewheel.xdsoft', function (event) {
					if (!options.scrollInput) {
						return true;
					}
					if (!options.datepicker && options.timepicker) {
						current_time_index = timebox.find('.xdsoft_current').length ? timebox.find('.xdsoft_current').eq(0).index() : 0;
						if (current_time_index + event.deltaY >= 0 && current_time_index + event.deltaY < timebox.children().length) {
							current_time_index += event.deltaY;
						}
						if (timebox.children().eq(current_time_index).length) {
							timebox.children().eq(current_time_index).trigger('mousedown');
						}
						return false;
					}
					if (options.datepicker && !options.timepicker) {
						datepicker.trigger(event, [event.deltaY, event.deltaX, event.deltaY]);
						if (input.val) {
							input.val(_xdsoft_datetime.str());
						}
						datetimepicker.trigger('changedatetime.xdsoft');
						return false;
					}
				});

			datetimepicker
				.on('changedatetime.xdsoft', function (event) {
					if (options.onChangeDateTime && $.isFunction(options.onChangeDateTime)) {
						var $input = datetimepicker.data('input');
						options.onChangeDateTime.call(datetimepicker, _xdsoft_datetime.currentTime, $input, event);
						delete options.value;
						$input.trigger('change');
					}
				})
				.on('generate.xdsoft', function () {
					if (options.onGenerate && $.isFunction(options.onGenerate)) {
						options.onGenerate.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'));
					}
					if (triggerAfterOpen) {
						datetimepicker.trigger('afterOpen.xdsoft');
						triggerAfterOpen = false;
					}
				})
				.on('click.xdsoft', function (xdevent) {
					xdevent.stopPropagation();
				});

			current_time_index = 0;

			setPos = function () {
				var offset = datetimepicker.data('input').offset(), top = offset.top + datetimepicker.data('input')[0].offsetHeight - 1, left = offset.left, position = "absolute", node;
				if (options.fixed) {
					top -= $(window).scrollTop();
					left -= $(window).scrollLeft();
					position = "fixed";
				} else {
					if (top + datetimepicker[0].offsetHeight > $(window).height() + $(window).scrollTop()) {
						top = offset.top - datetimepicker[0].offsetHeight + 1;
					}
					if (top < 0) {
						top = 0;
					}
					if (left + datetimepicker[0].offsetWidth > $(window).width()) {
						left = $(window).width() - datetimepicker[0].offsetWidth;
					}
				}

				node = datetimepicker[0];
				do {
					node = node.parentNode;
					if (window.getComputedStyle(node).getPropertyValue('position') === 'relative' && $(window).width() >= node.offsetWidth) {
						left = left - (($(window).width() - node.offsetWidth) / 2);
						break;
					}
				} while (node.nodeName !== 'HTML');
				datetimepicker.css({
					left: left,
					top: top,
					position: position
				});
			};
			datetimepicker
				.on('open.xdsoft', function (event) {
					var onShow = true;
					if (options.onShow && $.isFunction(options.onShow)) {
						onShow = options.onShow.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'), event);
					}
					if (onShow !== false) {
						datetimepicker.show();
						setPos();
						$(window)
							.off('resize.xdsoft', setPos)
							.on('resize.xdsoft', setPos);

						if (options.closeOnWithoutClick) {
							$([document.body, window]).on('mousedown.xdsoft', function arguments_callee6() {
								datetimepicker.trigger('close.xdsoft');
								$([document.body, window]).off('mousedown.xdsoft', arguments_callee6);
							});
						}
					}
				})
				.on('close.xdsoft', function (event) {
					var onClose = true;
					mounth_picker
						.find('.xdsoft_month,.xdsoft_year')
							.find('.xdsoft_select')
								.hide();
					if (options.onClose && $.isFunction(options.onClose)) {
						onClose = options.onClose.call(datetimepicker, _xdsoft_datetime.currentTime, datetimepicker.data('input'), event);
					}
					if (onClose !== false && !options.opened && !options.inline) {
						datetimepicker.hide();
					}
					event.stopPropagation();
				})
				.on('toggle.xdsoft', function (event) {
					if (datetimepicker.is(':visible')) {
						datetimepicker.trigger('close.xdsoft');
					} else {
						datetimepicker.trigger('open.xdsoft');
					}
				})
				.data('input', input);

			timer = 0;
			timer1 = 0;

			datetimepicker.data('xdsoft_datetime', _xdsoft_datetime);
			datetimepicker.setOptions(options);

			function getCurrentValue() {
				var ct = false, time;

				if (options.startDate) {
					ct = _xdsoft_datetime.strToDate(options.startDate);
				} else {
					ct = options.value || ((input && input.val && input.val()) ? input.val() : '');
					if (ct) {
						ct = _xdsoft_datetime.strToDateTime(ct);
					} else if (options.defaultDate) {
						ct = _xdsoft_datetime.strToDateTime(options.defaultDate);
						if (options.defaultTime) {
							time = _xdsoft_datetime.strtotime(options.defaultTime);
							ct.setHours(time.getHours());
							ct.setMinutes(time.getMinutes());
						}
					}
				}

				if (ct && _xdsoft_datetime.isValidDate(ct)) {
					datetimepicker.data('changed', true);
				} else {
					ct = '';
				}

				return ct || 0;
			}

			_xdsoft_datetime.setCurrentTime(getCurrentValue());

			input
				.data('xdsoft_datetimepicker', datetimepicker)
				.on('open.xdsoft focusin.xdsoft mousedown.xdsoft', function (event) {
					if (input.is(':disabled') || (input.data('xdsoft_datetimepicker').is(':visible') && options.closeOnInputClick)) {
						return;
					}
					clearTimeout(timer);
					timer = setTimeout(function () {
						if (input.is(':disabled')) {
							return;
						}

						triggerAfterOpen = true;
						_xdsoft_datetime.setCurrentTime(getCurrentValue());

						datetimepicker.trigger('open.xdsoft');
					}, 100);
				})
				.on('keydown.xdsoft', function (event) {
					var val = this.value, elementSelector,
						key = event.which;
					if ([ENTER].indexOf(key) !== -1 && options.enterLikeTab) {
						elementSelector = $("input:visible,textarea:visible");
						datetimepicker.trigger('close.xdsoft');
						elementSelector.eq(elementSelector.index(this) + 1).focus();
						return false;
					}
					if ([TAB].indexOf(key) !== -1) {
						datetimepicker.trigger('close.xdsoft');
						return true;
					}
				});
		};
		destroyDateTimePicker = function (input) {
			var datetimepicker = input.data('xdsoft_datetimepicker');
			if (datetimepicker) {
				datetimepicker.data('xdsoft_datetime', null);
				datetimepicker.remove();
				input
					.data('xdsoft_datetimepicker', null)
					.off('.xdsoft');
				$(window).off('resize.xdsoft');
				$([window, document.body]).off('mousedown.xdsoft');
				if (input.unmousewheel) {
					input.unmousewheel();
				}
			}
		};
		$(document)
			.off('keydown.xdsoftctrl keyup.xdsoftctrl')
			.on('keydown.xdsoftctrl', function (e) {
				if (e.keyCode === CTRLKEY) {
					ctrlDown = true;
				}
			})
			.on('keyup.xdsoftctrl', function (e) {
				if (e.keyCode === CTRLKEY) {
					ctrlDown = false;
				}
			});
		return this.each(function () {
			var datetimepicker = $(this).data('xdsoft_datetimepicker'), $input;
			if (datetimepicker) {
				if ($.type(opt) === 'string') {
					switch (opt) {
					case 'show':
						$(this).select().focus();
						datetimepicker.trigger('open.xdsoft');
						break;
					case 'hide':
						datetimepicker.trigger('close.xdsoft');
						break;
					case 'toggle':
						datetimepicker.trigger('toggle.xdsoft');
						break;
					case 'destroy':
						destroyDateTimePicker($(this));
						break;
					case 'reset':
						this.value = this.defaultValue;
						if (!this.value || !datetimepicker.data('xdsoft_datetime').isValidDate(Date.parseDate(this.value, options.format))) {
							datetimepicker.data('changed', false);
						}
						datetimepicker.data('xdsoft_datetime').setCurrentTime(this.value);
						break;
					case 'validate':
						$input = datetimepicker.data('input');
						$input.trigger('blur.xdsoft');
						break;
					}
				} else {
					datetimepicker
						.setOptions(opt);
				}
				return 0;
			}
			if ($.type(opt) !== 'string') {
				if (!options.lazyInit || options.open || options.inline) {
					createDateTimePicker($(this));
				} else {
					lazyInit($(this));
				}
			}
		});
	};
	$.fn.datetimepicker.defaults = default_options;
}(jQuery));

function HighlightedDate(date, desc, style) {
	"use strict";
	this.date = date;
	this.desc = desc;
	this.style = style;
}

(function () {

/*! Copyright (c) 2013 Brandon Aaron (http://brandon.aaron.sh)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Version: 3.1.12
 *
 * Requires: jQuery 1.2.2+
 */
!function(a){"function"==typeof define&&define.amd?define(["jquery"],a):"object"==typeof exports?module.exports=a:a(jQuery)}(function(a){function b(b){var g=b||window.event,h=i.call(arguments,1),j=0,l=0,m=0,n=0,o=0,p=0;if(b=a.event.fix(g),b.type="mousewheel","detail"in g&&(m=-1*g.detail),"wheelDelta"in g&&(m=g.wheelDelta),"wheelDeltaY"in g&&(m=g.wheelDeltaY),"wheelDeltaX"in g&&(l=-1*g.wheelDeltaX),"axis"in g&&g.axis===g.HORIZONTAL_AXIS&&(l=-1*m,m=0),j=0===m?l:m,"deltaY"in g&&(m=-1*g.deltaY,j=m),"deltaX"in g&&(l=g.deltaX,0===m&&(j=-1*l)),0!==m||0!==l){if(1===g.deltaMode){var q=a.data(this,"mousewheel-line-height");j*=q,m*=q,l*=q}else if(2===g.deltaMode){var r=a.data(this,"mousewheel-page-height");j*=r,m*=r,l*=r}if(n=Math.max(Math.abs(m),Math.abs(l)),(!f||f>n)&&(f=n,d(g,n)&&(f/=40)),d(g,n)&&(j/=40,l/=40,m/=40),j=Math[j>=1?"floor":"ceil"](j/f),l=Math[l>=1?"floor":"ceil"](l/f),m=Math[m>=1?"floor":"ceil"](m/f),k.settings.normalizeOffset&&this.getBoundingClientRect){var s=this.getBoundingClientRect();o=b.clientX-s.left,p=b.clientY-s.top}return b.deltaX=l,b.deltaY=m,b.deltaFactor=f,b.offsetX=o,b.offsetY=p,b.deltaMode=0,h.unshift(b,j,l,m),e&&clearTimeout(e),e=setTimeout(c,200),(a.event.dispatch||a.event.handle).apply(this,h)}}function c(){f=null}function d(a,b){return k.settings.adjustOldDeltas&&"mousewheel"===a.type&&b%120===0}var e,f,g=["wheel","mousewheel","DOMMouseScroll","MozMousePixelScroll"],h="onwheel"in document||document.documentMode>=9?["wheel"]:["mousewheel","DomMouseScroll","MozMousePixelScroll"],i=Array.prototype.slice;if(a.event.fixHooks)for(var j=g.length;j;)a.event.fixHooks[g[--j]]=a.event.mouseHooks;var k=a.event.special.mousewheel={version:"3.1.12",setup:function(){if(this.addEventListener)for(var c=h.length;c;)this.addEventListener(h[--c],b,!1);else this.onmousewheel=b;a.data(this,"mousewheel-line-height",k.getLineHeight(this)),a.data(this,"mousewheel-page-height",k.getPageHeight(this))},teardown:function(){if(this.removeEventListener)for(var c=h.length;c;)this.removeEventListener(h[--c],b,!1);else this.onmousewheel=null;a.removeData(this,"mousewheel-line-height"),a.removeData(this,"mousewheel-page-height")},getLineHeight:function(b){var c=a(b),d=c["offsetParent"in a.fn?"offsetParent":"parent"]();return d.length||(d=a("body")),parseInt(d.css("fontSize"),10)||parseInt(c.css("fontSize"),10)||16},getPageHeight:function(b){return a(b).height()},settings:{adjustOldDeltas:!0,normalizeOffset:!0}};a.fn.extend({mousewheel:function(a){return a?this.bind("mousewheel",a):this.trigger("mousewheel")},unmousewheel:function(a){return this.unbind("mousewheel",a)}})});

// Parse and Format Library
//http://www.xaprb.com/blog/2005/12/12/javascript-closures-for-runtime-efficiency/
/*
 * Copyright (C) 2004 Baron Schwartz <baron at sequent dot org>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, version 2.1.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
 * details.
 */
Date.parseFunctions={count:0};Date.parseRegexes=[];Date.formatFunctions={count:0};Date.prototype.dateFormat=function(b){if(b=="unixtime"){return parseInt(this.getTime()/1000);}if(Date.formatFunctions[b]==null){Date.createNewFormat(b);}var a=Date.formatFunctions[b];return this[a]();};Date.createNewFormat=function(format){var funcName="format"+Date.formatFunctions.count++;Date.formatFunctions[format]=funcName;var codePrefix="Date.prototype."+funcName+" = function() {return ";var code="";var special=false;var ch="";for(var i=0;i<format.length;++i){ch=format.charAt(i);if(!special&&ch=="\\"){special=true;}else{if(special){special=false;code+="'"+String.escape(ch)+"' + ";}else{code+=Date.getFormatCode(ch);}}}if(code.length==0){code="\"\"";}else{code=code.substring(0,code.length-3);}eval(codePrefix+code+";}");};Date.getFormatCode=function(a){switch(a){case"d":return"String.leftPad(this.getDate(), 2, '0') + ";case"D":return"Date.dayNames[this.getDay()].substring(0, 3) + ";case"j":return"this.getDate() + ";case"l":return"Date.dayNames[this.getDay()] + ";case"S":return"this.getSuffix() + ";case"w":return"this.getDay() + ";case"z":return"this.getDayOfYear() + ";case"W":return"this.getWeekOfYear() + ";case"F":return"Date.monthNames[this.getMonth()] + ";case"m":return"String.leftPad(this.getMonth() + 1, 2, '0') + ";case"M":return"Date.monthNames[this.getMonth()].substring(0, 3) + ";case"n":return"(this.getMonth() + 1) + ";case"t":return"this.getDaysInMonth() + ";case"L":return"(this.isLeapYear() ? 1 : 0) + ";case"Y":return"this.getFullYear() + ";case"y":return"('' + this.getFullYear()).substring(2, 4) + ";case"a":return"(this.getHours() < 12 ? 'am' : 'pm') + ";case"A":return"(this.getHours() < 12 ? 'AM' : 'PM') + ";case"g":return"((this.getHours() %12) ? this.getHours() % 12 : 12) + ";case"G":return"this.getHours() + ";case"h":return"String.leftPad((this.getHours() %12) ? this.getHours() % 12 : 12, 2, '0') + ";case"H":return"String.leftPad(this.getHours(), 2, '0') + ";case"i":return"String.leftPad(this.getMinutes(), 2, '0') + ";case"s":return"String.leftPad(this.getSeconds(), 2, '0') + ";case"O":return"this.getGMTOffset() + ";case"T":return"this.getTimezone() + ";case"Z":return"(this.getTimezoneOffset() * -60) + ";default:return"'"+String.escape(a)+"' + ";}};Date.parseDate=function(a,c){if(c=="unixtime"){return new Date(!isNaN(parseInt(a))?parseInt(a)*1000:0);}if(Date.parseFunctions[c]==null){Date.createParser(c);}var b=Date.parseFunctions[c];return Date[b](a);};Date.createParser=function(format){var funcName="parse"+Date.parseFunctions.count++;var regexNum=Date.parseRegexes.length;var currentGroup=1;Date.parseFunctions[format]=funcName;var code="Date."+funcName+" = function(input) {\nvar y = -1, m = -1, d = -1, h = -1, i = -1, s = -1, z = -1;\nvar d = new Date();\ny = d.getFullYear();\nm = d.getMonth();\nd = d.getDate();\nvar results = input.match(Date.parseRegexes["+regexNum+"]);\nif (results && results.length > 0) {";var regex="";var special=false;var ch="";for(var i=0;i<format.length;++i){ch=format.charAt(i);if(!special&&ch=="\\"){special=true;}else{if(special){special=false;regex+=String.escape(ch);}else{obj=Date.formatCodeToRegex(ch,currentGroup);currentGroup+=obj.g;regex+=obj.s;if(obj.g&&obj.c){code+=obj.c;}}}}code+="if (y > 0 && z > 0){\nvar doyDate = new Date(y,0);\ndoyDate.setDate(z);\nm = doyDate.getMonth();\nd = doyDate.getDate();\n}";code+="if (y > 0 && m >= 0 && d > 0 && h >= 0 && i >= 0 && s >= 0)\n{return new Date(y, m, d, h, i, s);}\nelse if (y > 0 && m >= 0 && d > 0 && h >= 0 && i >= 0)\n{return new Date(y, m, d, h, i);}\nelse if (y > 0 && m >= 0 && d > 0 && h >= 0)\n{return new Date(y, m, d, h);}\nelse if (y > 0 && m >= 0 && d > 0)\n{return new Date(y, m, d);}\nelse if (y > 0 && m >= 0)\n{return new Date(y, m);}\nelse if (y > 0)\n{return new Date(y);}\n}return null;}";Date.parseRegexes[regexNum]=new RegExp("^"+regex+"$",'i');eval(code);};Date.formatCodeToRegex=function(b,a){switch(b){case"D":return{g:0,c:null,s:"(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)"};case"j":case"d":return{g:1,c:"d = parseInt(results["+a+"], 10);\n",s:"(\\d{1,2})"};case"l":return{g:0,c:null,s:"(?:"+Date.dayNames.join("|")+")"};case"S":return{g:0,c:null,s:"(?:st|nd|rd|th)"};case"w":return{g:0,c:null,s:"\\d"};case"z":return{g:1,c:"z = parseInt(results["+a+"], 10);\n",s:"(\\d{1,3})"};case"W":return{g:0,c:null,s:"(?:\\d{2})"};case"F":return{g:1,c:"m = parseInt(Date.monthNumbers[results["+a+"].substring(0, 3)], 10);\n",s:"("+Date.monthNames.join("|")+")"};case"M":return{g:1,c:"m = parseInt(Date.monthNumbers[results["+a+"]], 10);\n",s:"(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)"};case"n":case"m":return{g:1,c:"m = parseInt(results["+a+"], 10) - 1;\n",s:"(\\d{1,2})"};case"t":return{g:0,c:null,s:"\\d{1,2}"};case"L":return{g:0,c:null,s:"(?:1|0)"};case"Y":return{g:1,c:"y = parseInt(results["+a+"], 10);\n",s:"(\\d{4})"};case"y":return{g:1,c:"var ty = parseInt(results["+a+"], 10);\ny = ty > Date.y2kYear ? 1900 + ty : 2000 + ty;\n",s:"(\\d{1,2})"};case"a":return{g:1,c:"if (results["+a+"] == 'am') {\nif (h == 12) { h = 0; }\n} else { if (h < 12) { h += 12; }}",s:"(am|pm)"};case"A":return{g:1,c:"if (results["+a+"] == 'AM') {\nif (h == 12) { h = 0; }\n} else { if (h < 12) { h += 12; }}",s:"(AM|PM)"};case"g":case"G":case"h":case"H":return{g:1,c:"h = parseInt(results["+a+"], 10);\n",s:"(\\d{1,2})"};case"i":return{g:1,c:"i = parseInt(results["+a+"], 10);\n",s:"(\\d{2})"};case"s":return{g:1,c:"s = parseInt(results["+a+"], 10);\n",s:"(\\d{2})"};case"O":return{g:0,c:null,s:"[+-]\\d{4}"};case"T":return{g:0,c:null,s:"[A-Z]{3}"};case"Z":return{g:0,c:null,s:"[+-]\\d{1,5}"};default:return{g:0,c:null,s:String.escape(b)};}};Date.prototype.getTimezone=function(){return this.toString().replace(/^.*? ([A-Z]{3}) [0-9]{4}.*$/,"$1").replace(/^.*?\(([A-Z])[a-z]+ ([A-Z])[a-z]+ ([A-Z])[a-z]+\)$/,"$1$2$3");};Date.prototype.getGMTOffset=function(){return(this.getTimezoneOffset()>0?"-":"+")+String.leftPad(Math.floor(Math.abs(this.getTimezoneOffset())/60),2,"0")+String.leftPad(Math.abs(this.getTimezoneOffset())%60,2,"0");};Date.prototype.getDayOfYear=function(){var a=0;Date.daysInMonth[1]=this.isLeapYear()?29:28;for(var b=0;b<this.getMonth();++b){a+=Date.daysInMonth[b];}return a+this.getDate();};Date.prototype.getWeekOfYear=function(){var b=this.getDayOfYear()+(4-this.getDay());var a=new Date(this.getFullYear(),0,1);var c=(7-a.getDay()+4);return String.leftPad(Math.ceil((b-c)/7)+1,2,"0");};Date.prototype.isLeapYear=function(){var a=this.getFullYear();return((a&3)==0&&(a%100||(a%400==0&&a)));};Date.prototype.getFirstDayOfMonth=function(){var a=(this.getDay()-(this.getDate()-1))%7;return(a<0)?(a+7):a;};Date.prototype.getLastDayOfMonth=function(){var a=(this.getDay()+(Date.daysInMonth[this.getMonth()]-this.getDate()))%7;return(a<0)?(a+7):a;};Date.prototype.getDaysInMonth=function(){Date.daysInMonth[1]=this.isLeapYear()?29:28;return Date.daysInMonth[this.getMonth()];};Date.prototype.getSuffix=function(){switch(this.getDate()){case 1:case 21:case 31:return"st";case 2:case 22:return"nd";case 3:case 23:return"rd";default:return"th";}};String.escape=function(a){return a.replace(/('|\\)/g,"\\$1");};String.leftPad=function(d,b,c){var a=new String(d);if(c==null){c=" ";}while(a.length<b){a=c+a;}return a;};Date.daysInMonth=[31,28,31,30,31,30,31,31,30,31,30,31];Date.monthNames=["January","February","March","April","May","June","July","August","September","October","November","December"];Date.dayNames=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];Date.y2kYear=50;Date.monthNumbers={Jan:0,Feb:1,Mar:2,Apr:3,May:4,Jun:5,Jul:6,Aug:7,Sep:8,Oct:9,Nov:10,Dec:11};Date.patterns={ISO8601LongPattern:"Y-m-d H:i:s",ISO8601ShortPattern:"Y-m-d",ShortDatePattern:"n/j/Y",LongDatePattern:"l, F d, Y",FullDateTimePattern:"l, F d, Y g:i:s A",MonthDayPattern:"F d",ShortTimePattern:"g:i A",LongTimePattern:"g:i:s A",SortableDateTimePattern:"Y-m-d\\TH:i:s",UniversalSortableDateTimePattern:"Y-m-d H:i:sO",YearMonthPattern:"F, Y"};
}());

/*! Copyright (c) 2011 Piotr Rochala (http://rocha.la)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Version: 1.3.6
 *
 */
(function($) {

  $.fn.extend({
    slimScroll: function(options) {

      var defaults = {

        // width in pixels of the visible scroll area
        width : 'auto',

        // height in pixels of the visible scroll area
        height : '250px',

        // width in pixels of the scrollbar and rail
        size : '7px',

        // scrollbar color, accepts any hex/color value
        color: '#000',

        // scrollbar position - left/right
        position : 'right',

        // distance in pixels between the side edge and the scrollbar
        distance : '1px',

        // default scroll position on load - top / bottom / $('selector')
        start : 'top',

        // sets scrollbar opacity
        opacity : .4,

        // enables always-on mode for the scrollbar
        alwaysVisible : false,

        // check if we should hide the scrollbar when user is hovering over
        disableFadeOut : false,

        // sets visibility of the rail
        railVisible : false,

        // sets rail color
        railColor : '#333',

        // sets rail opacity
        railOpacity : .2,

        // whether  we should use jQuery UI Draggable to enable bar dragging
        railDraggable : true,

        // defautlt CSS class of the slimscroll rail
        railClass : 'slimScrollRail',

        // defautlt CSS class of the slimscroll bar
        barClass : 'slimScrollBar',

        // defautlt CSS class of the slimscroll wrapper
        wrapperClass : 'slimScrollDiv',

        // check if mousewheel should scroll the window if we reach top/bottom
        allowPageScroll : false,

        // scroll amount applied to each mouse wheel step
        wheelStep : 20,

        // scroll amount applied when user is using gestures
        touchScrollStep : 200,

        // sets border radius
        borderRadius: '7px',

        // sets border radius of the rail
        railBorderRadius : '7px'
      };

      var o = $.extend(defaults, options);

      // do it for every element that matches selector
      this.each(function(){

      var isOverPanel, isOverBar, isDragg, queueHide, touchDif,
        barHeight, percentScroll, lastScroll,
        divS = '<div></div>',
        minBarHeight = 30,
        releaseScroll = false;

        // used in event handlers and for better minification
        var me = $(this);

        // ensure we are not binding it again
        if (me.parent().hasClass(o.wrapperClass))
        {
            // start from last bar position
            var offset = me.scrollTop();

            // find bar and rail
            bar = me.closest('.' + o.barClass);
            rail = me.closest('.' + o.railClass);

            getBarHeight();

            // check if we should scroll existing instance
            if ($.isPlainObject(options))
            {
              // Pass height: auto to an existing slimscroll object to force a resize after contents have changed
              if ( 'height' in options && options.height == 'auto' ) {
                me.parent().css('height', 'auto');
                me.css('height', 'auto');
                var height = me.parent().parent().height();
                me.parent().css('height', height);
                me.css('height', height);
              }

              if ('scrollTo' in options)
              {
                // jump to a static point
                offset = parseInt(o.scrollTo);
              }
              else if ('scrollBy' in options)
              {
                // jump by value pixels
                offset += parseInt(o.scrollBy);
              }
              else if ('destroy' in options)
              {
                // remove slimscroll elements
                bar.remove();
                rail.remove();
                me.unwrap();
                return;
              }

              // scroll content by the given offset
              scrollContent(offset, false, true);
            }

            return;
        }
        else if ($.isPlainObject(options))
        {
            if ('destroy' in options)
            {
            	return;
            }
        }

        // optionally set height to the parent's height
        o.height = (o.height == 'auto') ? me.parent().height() : o.height;

        // wrap content
        var wrapper = $(divS)
          .addClass(o.wrapperClass)
          .css({
            position: 'relative',
            overflow: 'hidden',
            width: o.width,
            height: o.height
          });

        // update style for the div
        me.css({
          overflow: 'hidden',
          width: o.width,
          height: o.height
        });

        // create scrollbar rail
        var rail = $(divS)
          .addClass(o.railClass)
          .css({
            width: o.size,
            height: '100%',
            position: 'absolute',
            top: 0,
            display: (o.alwaysVisible && o.railVisible) ? 'block' : 'none',
            'border-radius': o.railBorderRadius,
            background: o.railColor,
            opacity: o.railOpacity,
            zIndex: 90
          });

        // create scrollbar
        var bar = $(divS)
          .addClass(o.barClass)
          .css({
            background: o.color,
            width: o.size,
            position: 'absolute',
            top: 0,
            opacity: o.opacity,
            display: o.alwaysVisible ? 'block' : 'none',
            'border-radius' : o.borderRadius,
            BorderRadius: o.borderRadius,
            MozBorderRadius: o.borderRadius,
            WebkitBorderRadius: o.borderRadius,
            zIndex: 99
          });

        // set position
        var posCss = (o.position == 'right') ? { right: o.distance } : { left: o.distance };
        rail.css(posCss);
        bar.css(posCss);

        // wrap it
        me.wrap(wrapper);

        // append to parent div
        me.parent().append(bar);
        me.parent().append(rail);

        // make it draggable and no longer dependent on the jqueryUI
        if (o.railDraggable){
          bar.bind("mousedown", function(e) {
            var $doc = $(document);
            isDragg = true;
            t = parseFloat(bar.css('top'));
            pageY = e.pageY;

            $doc.bind("mousemove.slimscroll", function(e){
              currTop = t + e.pageY - pageY;
              bar.css('top', currTop);
              scrollContent(0, bar.position().top, false);// scroll content
            });

            $doc.bind("mouseup.slimscroll", function(e) {
              isDragg = false;hideBar();
              $doc.unbind('.slimscroll');
            });
            return false;
          }).bind("selectstart.slimscroll", function(e){
            e.stopPropagation();
            e.preventDefault();
            return false;
          });
        }

        // on rail over
        rail.hover(function(){
          showBar();
        }, function(){
          hideBar();
        });

        // on bar over
        bar.hover(function(){
          isOverBar = true;
        }, function(){
          isOverBar = false;
        });

        // show on parent mouseover
        me.hover(function(){
          isOverPanel = true;
          showBar();
          hideBar();
        }, function(){
          isOverPanel = false;
          hideBar();
        });

        // support for mobile
        me.bind('touchstart', function(e,b){
          if (e.originalEvent.touches.length)
          {
            // record where touch started
            touchDif = e.originalEvent.touches[0].pageY;
          }
        });

        me.bind('touchmove', function(e){
          // prevent scrolling the page if necessary
          if(!releaseScroll)
          {
  		      e.originalEvent.preventDefault();
		      }
          if (e.originalEvent.touches.length)
          {
            // see how far user swiped
            var diff = (touchDif - e.originalEvent.touches[0].pageY) / o.touchScrollStep;
            // scroll content
            scrollContent(diff, true);
            touchDif = e.originalEvent.touches[0].pageY;
          }
        });

        // set up initial height
        getBarHeight();

        // check start position
        if (o.start === 'bottom')
        {
          // scroll content to bottom
          bar.css({ top: me.outerHeight() - bar.outerHeight() });
          scrollContent(0, true);
        }
        else if (o.start !== 'top')
        {
          // assume jQuery selector
          scrollContent($(o.start).position().top, null, true);

          // make sure bar stays hidden
          if (!o.alwaysVisible) { bar.hide(); }
        }

        // attach scroll events
        attachWheel(this);

        function _onWheel(e)
        {
          // use mouse wheel only when mouse is over
          if (!isOverPanel) { return; }

          var e = e || window.event;

          var delta = 0;
          if (e.wheelDelta) { delta = -e.wheelDelta/120; }
          if (e.detail) { delta = e.detail / 3; }

          var target = e.target || e.srcTarget || e.srcElement;
          if ($(target).closest('.' + o.wrapperClass).is(me.parent())) {
            // scroll content
            scrollContent(delta, true);
          }

          // stop window scroll
          if (e.preventDefault && !releaseScroll) { e.preventDefault(); }
          if (!releaseScroll) { e.returnValue = false; }
        }

        function scrollContent(y, isWheel, isJump)
        {
          releaseScroll = false;
          var delta = y;
          var maxTop = me.outerHeight() - bar.outerHeight();

          if (isWheel)
          {
            // move bar with mouse wheel
            delta = parseInt(bar.css('top')) + y * parseInt(o.wheelStep) / 100 * bar.outerHeight();

            // move bar, make sure it doesn't go out
            delta = Math.min(Math.max(delta, 0), maxTop);

            // if scrolling down, make sure a fractional change to the
            // scroll position isn't rounded away when the scrollbar's CSS is set
            // this flooring of delta would happened automatically when
            // bar.css is set below, but we floor here for clarity
            delta = (y > 0) ? Math.ceil(delta) : Math.floor(delta);

            // scroll the scrollbar
            bar.css({ top: delta + 'px' });
          }

          // calculate actual scroll amount
          percentScroll = parseInt(bar.css('top')) / (me.outerHeight() - bar.outerHeight());
          delta = percentScroll * (me[0].scrollHeight - me.outerHeight());

          if (isJump)
          {
            delta = y;
            var offsetTop = delta / me[0].scrollHeight * me.outerHeight();
            offsetTop = Math.min(Math.max(offsetTop, 0), maxTop);
            bar.css({ top: offsetTop + 'px' });
          }

          // scroll content
          me.scrollTop(delta);

          // fire scrolling event
          me.trigger('slimscrolling', ~~delta);

          // ensure bar is visible
          showBar();

          // trigger hide when scroll is stopped
          hideBar();
        }

        function attachWheel(target)
        {
          if (window.addEventListener)
          {
            target.addEventListener('DOMMouseScroll', _onWheel, false );
            target.addEventListener('mousewheel', _onWheel, false );
          }
          else
          {
            document.attachEvent("onmousewheel", _onWheel)
          }
        }

        function getBarHeight()
        {
          // calculate scrollbar height and make sure it is not too small
          barHeight = Math.max((me.outerHeight() / me[0].scrollHeight) * me.outerHeight(), minBarHeight);
          bar.css({ height: barHeight + 'px' });

          // hide scrollbar if content is not long enough
          var display = barHeight == me.outerHeight() ? 'none' : 'block';
          bar.css({ display: display });
        }

        function showBar()
        {
          // recalculate bar height
          getBarHeight();
          clearTimeout(queueHide);

          // when bar reached top or bottom
          if (percentScroll == ~~percentScroll)
          {
            //release wheel
            releaseScroll = o.allowPageScroll;

            // publish approporiate event
            if (lastScroll != percentScroll)
            {
                var msg = (~~percentScroll == 0) ? 'top' : 'bottom';
                me.trigger('slimscroll', msg);
            }
          }
          else
          {
            releaseScroll = false;
          }
          lastScroll = percentScroll;

          // show only when required
          if(barHeight >= me.outerHeight()) {
            //allow window scroll
            releaseScroll = true;
            return;
          }
          bar.stop(true,true).fadeIn('fast');
          if (o.railVisible) { rail.stop(true,true).fadeIn('fast'); }
        }

        function hideBar()
        {
          // only hide when options allow it
          if (!o.alwaysVisible)
          {
            queueHide = setTimeout(function(){
              if (!(o.disableFadeOut && isOverPanel) && !isOverBar && !isDragg)
              {
                bar.fadeOut('slow');
                rail.fadeOut('slow');
              }
            }, 1000);
          }
        }

      });

      // maintain chainability
      return this;
    }
  });

  $.fn.extend({
    slimscroll: $.fn.slimScroll
  });

})(jQuery);
