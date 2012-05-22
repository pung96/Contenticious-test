perl 환경구축 최단코스
================================

저자
-------------------------------
[@pung96](https://twitter.com/pung96) - 물리학과 박사과정 학생. 현재 핀란드에 거주하면 스위스 제네바에 있는 LHC관련 연구를 진행중이다. 펄은 C++ 를 사용하다 지칠때 마음이 여유를 주기 위해 즐기는 정도. 

시작하며
-------------------------------
root 권한없이 모듈을 자유롭게 설치하고 싶다거나 여러 환경의 펄 버젼이나 모듈을 관리하고 싶다면 당신은 당신이 찾던 바로 그 글을 보고 있는 것이다. 이 주제는 여러번 되풀이 되었고 매우 훌륭하고 자세한 글들이 있지만, 여기서는 저자의 방법을 이용해 가능한 빠르고 적은 타이핑으로 개인 환경을 구축해보도록 하자. 이 글은 두 부분으로 나뉜다

* [cpanm] + [local::lib] : 시스템에 설치된 펄을 이용하여 자신의 모듈을 설치한다.
* [perlbrew] : 자신만의 perl을 설치(컴파일) 하고 다양한 라이브러리 모음 환경을 설정한다.

cpanm + local::lib
-------------------------------
cpanm 과 local::lib 를 이용해 사용자 환경을 구축한다. 일단 설치 과정을 보자.
### 설치 
다음 세줄을 실행한다.
<pre class="brush; bash">
export MYPERL=$HOME/perl5/mydev
curl -L http://cpanmin.us | perl -I $MYPERL - -l $MYPERL App::cpanminus
$MYPERL/bin/cpanm -l $MYPERL local::lib
</pre>
설치가 끝났다면 다음 두줄을 ```~/.bashrc```에 추가한다.
<pre>
export MYPERL=$HOME/perl5
function myperl () { S=${1-mydev};eval `perl -I $MYPERL/$S/lib/perl5 -Mlocal::lib=$MYPERL/$S`; }
</pre>
이제 당신은 ```mydev``` 라는 이름의 당신만의 환경을 만들었다."
### 사용
새 창을 열고 쉘(bash 쉘로 가정한다)에서 ```myperl mydev``` 을 실행한다.

	myperl mydev
	
 자 이제 mydev를 사용하기 위한 모든 준비가 끝났다. cpan 을 쓰건 cpanm 을 쓰건 모든 모듈은 myperl 디렉토리 아래에 설치되고 사용될 것이다. 
  
### 삭제
mydev 를 삭제하고 싶다면 $HOME/perl5/mydev 디렉토리를 삭제하면 된다.

### 추가
새로운 환경(myApp)을 설치하고 싶다면 ```MYPERL``` 을 바꾼후 cpanm과 local::lib 를 설치한다
<pre class="brush; bash">
export MYPERL=$HOME/perl5/myapp
curl -L http://cpanmin.us | perl -I $MYPERL - -l $MYPERL App::cpanminus
$MYPERL/bin/cpanm -l $MYPERL local::lib
</pre>
```~/.bashrc``` 는 그대로 둔다.
이제 필요에 따라 두가지 환경을 사용하면 된다.

	myperl mydev
	myperl myapp
 

perlbrew
---------------------------
### perlbrew 설치
먼저 perlbrew 를 ```$PERLBREW_ROOT```에 설치하자
    
    export PERLBREW_ROOT=$HOME/perl5/perlbrew
    curl -kL http://install.perlbrew.pl | bash
    source $PERLBREW_ROOT/etc/bashrc
    perlbrew install-cpanm   
    
perlbrew 설치가 끝났다면 다음 두줄을 ```~/.bashrc``` 에 추가한다.

    export PERLBREW_ROOT=$HOME/perl5/perlbrew
    alias myperlb='source $PERLBREW_ROOT/etc/bashrc'

자 이제 세창을 띄우고 ```myperlb``` 를 실행하면 perlbrew 를 사용하기 위한 준비가 끝난다.

	myperlb
	
### perl 설치
	perlbrew available				# 설치할 수 있는 perl 버젼 확인
	perlbrew install perl-5.14.2 	# perl 설치
	
perlbrew 는 펄을 컴파일하기 때문에 잠시 시간이 필요하다.

### 라이브러리 모음 추가
	perlbrew lib create perl-5.14.2@mydev 	# mydev 라는 라이브러리 모음을 만든다.
	perlbrew lib create perl-5.14.2@myapp 	# myapp 라는 라이브러리 모음을 만든다.
	perlbrew switch perl-5.14.2@mydev	    # perl-5.14.2@mydev 를 기본 환경으로 설정한다.
### 사용
	myperlb 					# 기본 라이브러 perl-5.14.2@mydev 사용환경
	perlbrew use perl-5.14.2@mydev			# perl-5.14.2@mydev 를 임시로 사용한다.
	
이제 cpanm 이나 cpan 을 사용하여 원하는 모듈을 설치하고 사용하면 된다. 

### 삭제
perl-5.14.2과 기본 라이브러리는 ~/perl5/perlbrew/perls/perl-5.14.2 에 설치되고
추가로 만든 ```mydev``` 와 ```myapp``` 는 ~/.perlbrew/lib 아래에 설치된다.

    perlbrew lib delete perl-5.14.2@mydev      # 라이브러리 삭제
    perlbrew uninstall  perl-5.14.2            # perl 삭제

### TIP
```alias``` 대신 ```function``` 을 사용하면 
<pre>
function myperlb () {
    source $PERLBREW_ROOT/etc/bashrc
    case "$1" in
        mydev ) perlbrew use perl-5.14.2@mydev; ;;
        myapp ) perlbrew use perl-5.14.2@myapp; ;;
    esac
    echo "You are using "`perlbrew list | grep '*'`
}
</pre>
다음처럼 사용할 수 있다.

    myperlb
    myperlb mydev
    myperlb myapp

 

끝마치며 
-----------------------------
개인적으로 자유도가 높은 perlbrew를 선호하기는 하지만 perlbrew 를 사용할 경우 perl 바이너리의 위치가 ```/usr/bin/perl``` 이 아닌 버젼에 따라 ```~/perl5/perlbrew/perls/perl-5.14.2/bin/perl``` 같은 형태이기 때문에 코드에서 ```#!/usr/bin/perl``` 이 아닌 ```#!/usr/bin/env perl``` 를 사용해야만한다.
문제는 시스템에 설치된 프로그램중 ```#!/usr/bin/perl```를 사용하면서 수정할 수 없는 것들이 있기 때문에
이경우는 어쩔수 없이 cpanm+local::lib 조합을 사용해야만 한다.  

See Also
------------------------------
* [perlbrew, local::lib, smartcd 를 이용하여 Perl 환경 구축하기](http://advent.perl.kr/2011/2011-12-16.html)  by corund
* [cpanm 이 당신의 Perl 생활을 윤택하게 해드립니다](http://jeen.tistory.com/entry/PerlCPAN-cpanm-이-당신의-Perl-생활을-윤택하게-해드립니다) by jeen
* [Perl Module 수동 설치](http://aero.springnote.com/pages/753034) by aero
* [pung96의 perl 관련 글](http://tum.pung96.net/tagged/perl)
* [cpanm] in CPAN
* [local::lib] in CPAN
* [perlbrew] in CPAN

[perlbrew]:https://metacpan.org/module/perlbrew
[cpanm]:https://metacpan.org/module/cpanm
[local::lib]:https://metacpan.org/module/local::lib