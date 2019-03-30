\RequirePackage { expl3 , l3keys2e }

\ProvidesExplClass
  {tufte-thesis}
  {2017/12/12}
  {0.01}
  {A Tufte-like thesis class derived from tufte-book}


\RequirePackage { xparse }

%%%%%%%%%%%%%%%%%
% Class options %
%%%%%%%%%%%%%%%%%

\tl_new:N \l_thesis_class_tl

\keys_define:nn { tufte-thesis }
  {
    class .tl_gset:N = \l_thesis_class_tl ,
    class .value_required:n = true ,

    class .initial:n = tufte-book
  }

\keys_define:nn { tufte-thesis }
  {
    tufte-book .choice: ,
    tufte-book / true .meta:n = { class = tufte-book } ,
    tufte-book / false .meta:n = { class = tufte-handout } ,

    tufte-book .default:n = true
  }

\keys_define:nn { tufte-thesis }
  {
    tufte-handout .choice: ,
    tufte-handout / true .meta:n = { class = tufte-handout } ,
    tufte-handout / false .meta:n = { class = tufte-book } ,

    tufte-handout .default:n = true
  }


\bool_new:N \l_thesis_libertine_bool

\keys_define:nn { tufte-thesis }
  {
    libertine .bool_set:N = \l_thesis_libertine_bool ,
    libertine .default:n = true ,

    libertine .initial:n = true ,
  }


\tl_new:N \l_thesis_biboptions_tl

\keys_define:nn { tufte-thesis }
  {
    biblatex .tl_gset:N = \l_thesis_biboptions_tl ,
    biblatex .value_required:n = true ,
  }


%%%%%%%%%%%%%%%%%
% Color schemes %
%%%%%%%%%%%%%%%%%

\keys_define:nn { tufte-thesis }
  {
    color~scheme .code:n =
      \keys_set:nn { tufte-thesis / colors } {#1}
    ,
  }

\clist_map_inline:nn { structure , code }
  {
    \keys_define:nn { tufte-thesis / colors }
      {
        #1 .code:n = \colorlet {#1} {##1} ,
        #1 .value_required:n = true
      }
  }


%%%%%%%%%%%%%%
% Base class %
%%%%%%%%%%%%%%

\ProcessKeysOptions { tufte-thesis }

\PassOptionsToClass
  { justified , nobib }
  { \l_thesis_class_tl }

\bool_if:NT \l_thesis_libertine_bool
  { \PassOptionsToClass { nofonts } { \l_thesis_class_tl } }

\LoadClass { \l_thesis_class_tl }


% 

\RequirePackage { xcolor }

\xdefinecolor { beachblue } { HTML } { 046380 }
\xdefinecolor { firenzered } { HTML } { 8E2800 }

\keys_define:nn { tufte-thesis / colors }
  {
    structure .initial:n = beachblue ,
    code      .initial:n = beachblue ,
  }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fonts and microtypography %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\bool_if:NT \l_thesis_libertine_bool
  {
    %% Libertine roman text
    \PassOptionsToPackage
      { semibold , lining , tt = false }
      { libertine }
    \RequirePackage { libertine }
  }

\PassOptionsToPackage { T1 } { fontenc }
\RequirePackage { fontenc }

\PassOptionsToPackage
  { supstfm = libertinesups , supscaled = 1.2 , raised = -.13em }
  { superiors }
\RequirePackage { superiors }


\makeatletter
\long\def\@makefntext#1{\llap{\textsu{\@thefnmark}\,}\footnotelayout#1}
\makeatother


%% Microtypography
\PassOptionsToPackage
  {
    expansion = false ,
    tracking = smallcaps ,
    letterspace = 40
  } { microtype }

\RequirePackage { microtype }

%% Math fonts

% Other math fonts
\RequirePackage { amsmath }
\RequirePackage { amssymb }

\PassOptionsToPackage { heavycircles } { stmaryrd }
\RequirePackage { stmaryrd }

% newtx math fonts
\bool_if:NT \l_thesis_libertine_bool
  {
    \RequirePackage { amsthm }

    \PassOptionsToPackage
      { libertine , cmintegrals , bigdelims , vvarbb , liby }
      { newtxmath }
    \RequirePackage { newtxmath }
  }

% Switch to old-style figures in text
\useosf


%%%%%%%%%%%%%
% Sidenotes %
%%%%%%%%%%%%%

\RequirePackage { mparhack }


%%%%%%%%%%%%%%%%%%%%%
% Table of Contents %
%%%%%%%%%%%%%%%%%%%%%

\setcounter{tocdepth}{2} % Show sections and subsections


%%%%%%%%%%%%%%%%%%%
% Format of heads %
%%%%%%%%%%%%%%%%%%%

\setcounter { secnumdepth } { 2 } % Numbering for sections

%% Italic A- and B-heads with margin numbering
\titleformat { \section } [ hang ]
  { \Large \itshape \color{ structure } }
  { \llap { \normalfont \thesection \kern1em } }
  { 0em }{}[]

\titleformat { \subsection } [ hang ]
  { \large \itshape \color{ structure } }
  { \llap { \normalfont \thesubsection \kern1em } }
  { 0em } { } [ ]

%% Small caps run-in unnumbered C-heads
\titleformat { \paragraph } [ runin ]
  { \scshape \color{ structure } }
  { }
  { 1em } { \MakeTextLowercase } [ ]


%%%%%%%%%%%%%%%%
% Inline lists %
%%%%%%%%%%%%%%%%

\PassOptionsToPackage { inline } { enumitem }
\RequirePackage { enumitem }


%%%%%%%%%%%%%%
% Quotations %
%%%%%%%%%%%%%%

% \PassOptionsToPackage { english } { csquotes }
\RequirePackage { csquotes }


%%%%%%%%%%%%%%%%%%%%%%%%
% Theorem environments %
%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage { amsthm }
\RequirePackage { thmtools }

%% Small caps theorem styles
\declaretheoremstyle [
  spaceabove = \topsep , spacebelow = \topsep ,
  bodyfont = \normalfont \itshape ,
  headfont = \normalfont \scshape \color { structure } ,
  notefont = \normalfont \color { black } ,
  headpunct = { \textcolor { black } { . } } ,
  postheadspace = .5em
] { smallcaps-plain }

\declaretheoremstyle [
  spaceabove = \topsep , spacebelow = \topsep ,
  bodyfont = \normalfont ,
  headfont = \normalfont \scshape \color { structure } ,
  notefont = \normalfont \color { black } ,
  headpunct = { \textcolor { black } { . } } ,
  postheadspace = .5em
] { smallcaps-definition }

%% Proof environment 
\cs_set_eq:NN \__proof \proof
\cs_set_eq:NN \__endproof \endproof

\RenewDocumentEnvironment { proof } { O{ Proof } }
  { \__proof [ \color { structure } #1 ] }
  { \__endproof }

%% Some theorem-like environments
\declaretheorem
  [ numberwithin = chapter ,
    refname = { theorem , theorems } ,
    Refname = { Theorem , Theorems } ,
    style = smallcaps-plain ]
  { theorem }

\declaretheorem
  [ sibling = theorem ,
    refname = { lemma , lemmas } ,
    Refname = { Lemma , Lemmas } ,
    style = smallcaps-plain ]
  { lemma }

\declaretheorem
  [ sibling = theorem ,
    refname = { corollary , corollaries } ,
    Refname = { Corollary , Corollaries } ,
    style = smallcaps-plain ]
  { corollary }

\declaretheorem
  [ sibling = theorem ,
    name = False~claim ,
    refname = { false~claim , false~claims } ,
    Refname = { False~claim , False~claims } ,
    style = smallcaps-plain ]
  { falseclaim }

\newtheorem* { theorem* } { Theorem }
\newtheorem* { lemma* } { Lemma }
\newtheorem* { corollary* } { Corollary }
\newtheorem { fact } [ theorem ] { Fact }
\newtheorem* { fact* } { Fact }
\newtheorem* { falseclaim* } { False~Claim }
\newtheorem { conjecture } [ theorem ] { Conjecture }
\newtheorem* { conjecture* } { Conjecture }

\declaretheorem
  [ numberwithin = chapter ,
    refname = { definition , definitions } ,
    Refname = { Definition , Definitions } ,
    style = smallcaps-definition ]
  { definition }

\declaretheorem
  [ numberwithin = chapter ,
    refname = { example , examples } ,
    Refname = { Example , Examples } ,
    style = smallcaps-definition ,
    qed = \qedsymbol ]
  { example }

\newtheorem* { definition* } { Definition }
\newtheorem* { example* } { Example }

%% QED symbol in structure color
\cs_set:Npn \qedsymbol { $ \color { structure } \Box $ }

%% Description environment for use in theorems/definitions
\PassOptionsToPackage { inline } { enumitem }
\RequirePackage { enumitem }

\newlist { thmdescription } { description } { 1 }
\setlist [ thmdescription ] { nosep , leftmargin=1.25em ,  , font=\emph }


%%%%%%%%%%%
% Figures %
%%%%%%%%%%%

% Remove \FloatBarrier from marginfigure definition
% to prevent unwanted spaces.
\makeatletter
\renewenvironment{@tufte@margin@float}[2][-1.2ex]{%
  %\FloatBarrier% removed because it adds unwanted white space
  \begin{lrbox}{\@tufte@margin@floatbox}%
  \begin{minipage}{\marginparwidth}%
    \@tufte@caption@font
    \def\@captype{#2}%
    \hbox{}\vspace*{#1}%
    \@tufte@caption@justification
    \@tufte@margin@par
    \noindent
}{%
  \end{minipage}%
  \end{lrbox}%
  \marginpar{\usebox{\@tufte@margin@floatbox}}%
}
\makeatother


%%%%%%%%%%%%%%%%
% Bibliography %
%%%%%%%%%%%%%%%%

\exp_args:No \PassOptionsToPackage { \l_thesis_biboptions_tl } { biblatex }
\RequirePackage { biblatex }


%%%%%%%%%%%%%
% Utilities %
%%%%%%%%%%%%%

\RequirePackage { import }


%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels and references %
%%%%%%%%%%%%%%%%%%%%%%%%%


% \PassOptionsToPackage { colorlinks = true , allcolors = red } { hyperref }
\RequirePackage { hyperref }
  
\RequirePackage { cleveref }

% \crefname{lemma}{lem.}{lems.}
% \Crefname{lemma}{Lemma}{Lemmas}

\NewDocumentCommand \parencref { O{} m O{} }
  { \__thesis_parencref:nnn {#1} {#2} {#3} }
\cs_new:Npn \__thesis_parencref:nnn #1 #2 #3
  {
    \nobreakspace (
    \tl_if_empty:nF {#1} { #1 ~ }
    \cref{#2}
    \tl_if_empty:nF {#3} {#3}
    )
  }
