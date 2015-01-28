describe "StockorDemoAccess.Screens.Base", ->

    it "can be instantiated", ->
        view = new StockorDemoAccess.Screens.Base()
        expect(view).toEqual(jasmine.any(StockorDemoAccess.Screens.Base));
