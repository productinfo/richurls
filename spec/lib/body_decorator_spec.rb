require 'spec_helper'

RSpec.describe RichUrls::BodyDecorator do
  let(:url) { 'https://body.com' }

  describe 'title decorator' do
    it 'decorates a html body' do
      file = File.read('./spec/fixtures/title_only.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['title']).to eq('This is a title')
      expect(result['embed']).to eq(nil)
    end

    it 'selects the meta title over the title' do
      file = File.read('./spec/fixtures/meta_title.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['title']).to eq('This is another title')
    end
  end

  describe 'description decorator' do
    it 'decorates a html body' do
      file = File.read('./spec/fixtures/meta_description.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['description']).to eq('This is a description')
    end
  end

  describe 'image decorator' do
    it 'decorates a html body - appends the url' do
      file = File.read('./spec/fixtures/meta_image.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['image']).to eq('https://body.com/cats.jpg')
    end

    it 'decorates a html body - does not append with a non-relative url' do
      file = File.read('./spec/fixtures/image_tags.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['image']).to eq('https://www.test.com/smiley1.gif')
    end

    it 'decorates a html body - appends the url' do
      file = File.read('./spec/fixtures/relative_image_tags.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['image']).to eq('https://body.com/smiley1.gif')
    end
  end

  describe 'embed decorator' do
    it 'fetches the embed code from a page like Youtube' do
      file = File.read('./spec/fixtures/youtube_video.html')
      decorator = RichUrls::BodyDecorator.new(
        'https://www.youtube.com/watch?v=ONYyFiKjJ20',
        file
      )

      result = decorator.decorate

      expect(result['embed']).to eq(
        '<iframe width="560" height="315" src="https://www.youtube.com/embedONYyFiKjJ20" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'
      )
    end

    it 'fetches the embed code from a page like Paste' do
      file = File.read('./spec/fixtures/paste_slideshow.html')
      decorator = RichUrls::BodyDecorator.new(
        'https://pasteapp.com/p/jbYfTeB8726?view=xhund8bMW4W',
        file
      )
      result = decorator.decorate

      expect(result['embed']).to eq(
        '<iframe src="https://pasteapp.com/p/jbYfTeB8726/embed?view=xhund8bMW4W" width="480" height="480" scrolling="no" frameborder="0" allowfullscreen></iframe>'
      )
    end
  end
end
