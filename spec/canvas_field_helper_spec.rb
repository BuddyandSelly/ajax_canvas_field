# frozen_string_literal: true

RSpec.describe CanvasFieldHelper do
  # Nokogiri is not a dependency of the gem, so the specs read the attributes
  # content_tag wrote straight out of the markup.
  def attribute(markup, name)
    markup[/#{Regexp.escape(name)}="([^"]*)"/, 1]
  end

  describe '#canvas_field' do
    it 'posts to the canvas_fields controller by default' do
      expect(attribute(view.canvas_field, 'data-url')).to eq('/canvas_fields')
    end

    it 'takes the controller of the endpoint' do
      expect(attribute(view.canvas_field(controller: 'drawings'), 'data-url')).to eq('/drawings')
    end

    it 'puts the namespace in front of the controller' do
      markup = view.canvas_field(namespace: 'api/v1', controller: 'drawings')

      expect(attribute(markup, 'data-url')).to eq('/api/v1/drawings')
    end

    it 'keeps the scheme of an absolute server url' do
      markup = view.canvas_field(server: 'https://example.com', controller: 'drawings')

      expect(attribute(markup, 'data-url')).to eq('https://example.com/drawings')
    end

    it 'collapses the double slashes of the parts it joins' do
      markup = view.canvas_field(server: 'https://example.com/', namespace: '/api/', controller: '/drawings')

      expect(attribute(markup, 'data-url')).to eq('https://example.com/api/drawings')
    end

    it 'derives the strong parameter from the controller' do
      expect(attribute(view.canvas_field(controller: 'drawings'), 'data-strong-param')).to eq('drawing')
    end

    it 'takes the strong parameter as it is given' do
      markup = view.canvas_field(controller: 'drawings', param: 'sketch')

      expect(attribute(markup, 'data-strong-param')).to eq('sketch')
    end

    it 'falls back to canvas_field without a controller' do
      expect(attribute(view.canvas_field, 'data-strong-param')).to eq('canvas_field')
    end

    it 'uses the configured size' do
      AjaxCanvasField.configure(default_width: 800, default_height: 600)
      markup = view.canvas_field

      expect(attribute(markup, 'data-width')).to eq('800')
      expect(attribute(markup, 'data-height')).to eq('600')
    end

    it 'takes a size of its own' do
      markup = view.canvas_field(width: 100, height: 200)

      expect(attribute(markup, 'data-width')).to eq('100')
      expect(attribute(markup, 'data-height')).to eq('200')
    end

    it 'takes the colours and the active buttons' do
      markup = view.canvas_field(left_color: '#111111', middle_color: '#222222', right_color: '#333333',
                                 left_active: true, middle_active: true, right_active: true)

      expect(attribute(markup, 'data-left-color')).to eq('#111111')
      expect(attribute(markup, 'data-middle-color')).to eq('#222222')
      expect(attribute(markup, 'data-right-color')).to eq('#333333')
      expect(attribute(markup, 'data-left-active')).to eq('true')
      expect(attribute(markup, 'data-middle-active')).to eq('true')
      expect(attribute(markup, 'data-right-active')).to eq('true')
    end

    it 'leaves the background empty without a background url' do
      expect(attribute(view.canvas_field, 'style')).to eq('background: #fff  no-repeat center top')
    end

    it 'puts a background url in the style' do
      markup = view.canvas_field(background_url: '/plan.png')

      expect(attribute(markup, 'style')).to eq('background: #fff url(/plan.png) no-repeat center top')
    end

    it 'keeps the classes of the caller next to its own' do
      expect(attribute(view.canvas_field(class: 'wide'), 'class')).to eq('wide canvas_field')
    end

    it 'takes an id' do
      expect(attribute(view.canvas_field(id: 'plan'), 'id')).to eq('plan')
    end

    it 'says so when the browser has no canvas' do
      expect(view.canvas_field).to include('Your browser does not support the canvas element.')
    end

    describe 'the token' do
      it 'takes the token it is given' do
        expect(attribute(view.canvas_field(token: 'TOKEN'), 'data-token')).to eq('TOKEN')
      end

      it 'reads the token of the authentication in the session' do
        authentication = instance_double(Struct.new(:token), token: 'SESSION_TOKEN')
        allow(view).to receive(:session).and_return(authentication: authentication)

        expect(attribute(view.canvas_field, 'data-token')).to eq('SESSION_TOKEN')
      end

      it 'sends no token when nobody is authenticated' do
        expect(view.canvas_field).not_to include('data-token')
      end
    end
  end

  describe '#canvas_data_field' do
    it 'is not active by default' do
      expect(attribute(view.canvas_data_field, 'class')).to eq(' canvas_data_field')
    end

    it 'is active when it is told to be' do
      expect(attribute(view.canvas_data_field(true), 'class')).to eq('active canvas_data_field')
    end

    it 'carries its data as json' do
      markup = view.canvas_data_field(false, additional_data: { 'a' => 1 }, initial_data: [{ 'x' => 2 }])

      expect(attribute(markup, 'data-additional-data')).to eq('{&quot;a&quot;:1}')
      expect(attribute(markup, 'data-initial-data')).to eq('[{&quot;x&quot;:2}]')
    end

    it 'carries the symbol of the dot and the field it belongs to' do
      markup = view.canvas_data_field(false, content: 'A', for: 'plan')

      expect(attribute(markup, 'data-content')).to eq('A')
      expect(attribute(markup, 'data-for')).to eq('plan')
    end

    it 'has no content by default' do
      expect(attribute(view.canvas_data_field, 'data-content')).to eq('')
    end
  end

  describe '#canvas_legend_field' do
    it 'renders a header and the mouse icons by default' do
      markup = view.canvas_legend_field

      expect(markup).to include('Linke Maustaste', 'Mittlere Maustaste', 'Rechte Maustaste')
      expect(markup).to include('mouse_left', 'mouse_middle', 'mouse_right')
    end

    it 'hides the header' do
      expect(view.canvas_legend_field(no_header: true)).not_to include('Linke Maustaste')
    end

    it 'hides the mouse icons' do
      expect(view.canvas_legend_field(no_icon: true)).not_to include('mouse_left')
    end

    it 'renders the text of every button' do
      markup = view.canvas_legend_field(left_text: 'Scratch', middle_text: 'Dent', right_text: 'Crack')

      expect(markup).to include('Scratch', 'Dent', 'Crack')
    end

    it 'renders the initial of a button behind its text' do
      markup = view.canvas_legend_field(left_text: 'Scratch', left_initial: 'S')

      expect(markup).to include('Scratch', '(S)')
    end

    it 'leaves out the brackets without an initial' do
      expect(view.canvas_legend_field(left_text: 'Scratch')).not_to include('()')
    end

    it 'says which buttons are active' do
      markup = view.canvas_legend_field(left_active: true)

      expect(markup.scan('Aktiviert').size).to eq(1)
      expect(markup.scan('Deaktiviert').size).to eq(2)
    end

    it 'paints the colour of every button' do
      markup = view.canvas_legend_field(left_color: '#111111', middle_color: '#222222', right_color: '#333333')

      expect(markup).to include('background-color: #111111', 'background-color: #222222',
                                'background-color: #333333')
    end

    it 'paints red by default' do
      expect(view.canvas_legend_field.scan('background-color: #ff0000').size).to eq(3)
    end
  end

  describe '#ro_canvas_field' do
    it 'uses the configured size' do
      markup = view.ro_canvas_field

      expect(attribute(markup, 'data-width')).to eq('470')
      expect(attribute(markup, 'data-height')).to eq('470')
    end

    it 'halves the size and the background on request' do
      markup = view.ro_canvas_field(width: 400, height: 300, half_size: true)

      expect(attribute(markup, 'data-width')).to eq('200')
      expect(attribute(markup, 'data-height')).to eq('150')
      expect(attribute(markup, 'style')).to include('background-size: 200px 150px')
    end

    it 'carries the initial data as json' do
      markup = view.ro_canvas_field(initial_data: [{ 'x' => 2 }])

      expect(attribute(markup, 'data-initial-data')).to eq('[{&quot;x&quot;:2}]')
    end

    it 'takes the colours' do
      markup = view.ro_canvas_field(left_color: '#111111', middle_color: '#222222', right_color: '#333333')

      expect(attribute(markup, 'data-left-color')).to eq('#111111')
      expect(attribute(markup, 'data-middle-color')).to eq('#222222')
      expect(attribute(markup, 'data-right-color')).to eq('#333333')
    end

    it 'puts a background url in the style' do
      markup = view.ro_canvas_field(background_url: '/plan.png')

      expect(attribute(markup, 'style')).to eq('background: #fff url(/plan.png) no-repeat center top')
    end

    it 'leaves the background empty without a background url' do
      expect(attribute(view.ro_canvas_field, 'style')).to eq('background: #fff  no-repeat center top')
    end

    it 'keeps the classes of the caller next to its own and takes an id' do
      markup = view.ro_canvas_field(class: 'wide', id: 'plan')

      expect(attribute(markup, 'class')).to eq('wide ro_canvas_field')
      expect(attribute(markup, 'id')).to eq('plan')
    end
  end
end
