FULL = {left: 0, top: 0, width: '100%', height: '100%'}
# right: 0, bottom: 0

OVERLAY  = null
VIEWPORT = null

class RootComponent extends Lanes.React.Component

    close: ->
        Lanes.Screens.Definitions.displaying.reset()
        VIEWPORT.close()
        OVERLAY.hide()

    render: ->
        <div className="layout">
            <BS.Button
                className="demo-overlay-hide"
                bsStyle='primary' onClick={@close}
            >Hide</BS.Button>
            <Lanes.Workspace.Layout />
        </div>


class Overlay

    constructor: ->
        _.extend(@,
            isShown: false
            hidden: true
        )
        @el = _.dom(document.createElement('div'))
        @el.addClass('demo-overlay')
        @el.setStyle(position: 'fixed')
        @el.on('transitionend', => @onTransition(arguments...))
        document.body.appendChild(@el.el)

    onTransition: _.debounce (ev) ->
        return unless @el.el is ev.target
        if @isShown
            if Lanes.current_user.isLoggedIn
                Lanes.Screens.Definitions.all.get(@screenId).display()
            else
                Lanes.Extensions.get('lanes-access').showLogin()
                Lanes.current_user.once('change:isLoggedIn', =>
                    Lanes.Screens.Definitions.all.get(@screenId).display()
                )
        else
            @el.addClass('hidden')


    hide: ->
        @el.removeClass('hidden')
        @setSizeToOrigin()
        @isShown = false

    show: (@screenId, @origin) ->
        @isShown = true
        @el.addClass('hidden')
        @setSizeToOrigin()
        @el.removeClass('hidden')
        @el.show()
        _.defer =>
            @el.setStyle(FULL)

    setSizeToOrigin: ->
        size = _.pick @origin.getBoundingClientRect(), _.keys FULL
        @el.setStyle( _.mapValues(size, (v) -> "#{v}px") )



StockorDemo.displayFeature = (screenId, el) ->
    if OVERLAY
        OVERLAY.show(screenId, el)
    else
        OVERLAY = new Overlay

        Lanes.Models.Sync.perform('read',
            url: '/api/boostrap'
        ).then (config) ->
            config = _.omit(config, 'api_path', 'api_host')
            Lanes.config.bootstrap(config)
            VIEWPORT = new Lanes.React.Viewport(
                _.extend(config,
                    useHistory: false
                    rootComponent: RootComponent
                    selector: '.demo-overlay'
                )
            )
            OVERLAY.show(screenId, el)
