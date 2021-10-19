
def common_pod 
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Kingfisher'

end 

def testing_pod
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxTest'
end

target 'ImageGallery-DEV' do
  common_pod
end

target 'ImageGallery-PROD' do
  common_pod
end

target 'ImageGallery-STG' do
  common_pod
end

target 'ImageGallery-Test' do
  testing_pod
end
