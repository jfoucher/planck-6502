
import * as THREE from 'three';

import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { VRMLLoader } from 'three/addons/loaders/VRMLLoader.js';


import {emu} from './planckemu.js';
import planckModule from './planckemu.wasm';

export var loadedModule = null;

const ioEl = document.getElementById('io');

let keypressed = null;

const module = emu({
  locateFile(path) {
    if(path.endsWith('.wasm')) {
      return planckModule;
    }
    return path;
  },
  print: function(text) {
    if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
    console.log(text);
    ioEl.value = ioEl.value + text;
    ioEl.scrollTop = ioEl.scrollHeight;
  },

  preRun: [
    function(e) {
        console.log('preRun', e)
        function stdin() {
            const k = keypressed
            keypressed = null
            if (k) {
                console.log(k);
                return k
            }
            return 0;
        }
        function stdout(c) {
            ioEl.value = ioEl.value + String.fromCharCode(c);
            ioEl.scrollTop = ioEl.scrollHeight;
        }
        function stderr(c) {
            console.err('err', c);
        }

        e.FS.init(stdin, stdout, stderr);
    }
  ]

}).then(instance => {
   console.log("module ready!", instance);

   loadedModule = instance;

   document.getElementById('choose-rom').addEventListener('change', function(e) {
    if (e.target.files[0]) {
      chooseRom(e.target.files[0]);
    }
  });
  document.getElementById('reset-btn').addEventListener('click', function(e) {
    console.log('reset_6502')
    loadedModule.ccall('reset_6502', null, null)
    loadedModule._reset_6502(null);
  });

  document.getElementById('run-btn').addEventListener('click', function(e) {
    console.log('run')
    loadedModule.ccall("run_6502", "void", ["number"], 100)
    console.log('ran')
  });
  ioEl.addEventListener('keyup', function(ev) {
    console.log(ev.keyCode);
    keypressed = ev.keyCode
    //loadedModule.ccall("receive_char", "void", ["number"], [c])
  })
 });



let camera, scene, renderer, stats, controls, loader;



let vrmlScene;

let mouse, raycaster, labelRenderer

init();
animate();

function init() {

    const cv = document.getElementById('canvas')
    camera = new THREE.PerspectiveCamera( 60, 640/480, 0.01, 1e10 );
    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2(-10000, -100000)


    scene = new THREE.Scene();
    scene.add( camera );
    camera.position.set( 0.1, 0.2, 0.2 );
    
    // light

    const hemiLight = new THREE.HemisphereLight( 0xffffff, 0x000000, 1 );
    scene.add( hemiLight );
    const axesHelper = new THREE.AxesHelper( 0.5 );
    scene.add( axesHelper );

    const dirLight = new THREE.DirectionalLight( 0xffffff, 0.5 );
    dirLight.position.set( 200, 200, 200 );
    scene.add( dirLight );

    // const geometry = new THREE.BoxGeometry( 0.1, 0.1, 0.1 );
    // const material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
    // const cube = new THREE.Mesh( geometry, material );
    // scene.add( cube );

    //loader = new VRMLLoader();
    //loadAsset( "mainboard.wrl" );

    // renderer
    
    renderer = new THREE.WebGLRenderer();
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( 640, 480 );
    document.getElementById('canvas-container').appendChild( renderer.domElement );

    // controls

    controls = new OrbitControls( camera, renderer.domElement );
    controls.minDistance = 0.01;
    controls.maxDistance = 200;
    controls.enableDamping = false;
    controls.target = new THREE.Vector3(0.1, 0, 0)

    controls.update();

    window.addEventListener( 'resize', onWindowResize );



}

function loadAsset( asset ) {
    loader.load( 'mainboard.wrl', function ( object ) {
        vrmlScene = object;
        vrmlScene.rotateX(-Math.PI/2)
        console.log('object', vrmlScene);
        scene.add( vrmlScene );
        const c = document.getElementById('canvas-container').children

        const cv = Array.from(c).find(n => n.nodeName === 'CANVAS')

        cv.addEventListener('mousemove', function(evt) {
            getMousePos(cv, evt);
        }, false);
        cv.addEventListener('click', function(evt) {
            getMousePos(cv, evt);
            raycaster.setFromCamera(mouse, camera);
            const s = scene.children.find(sc => sc.type === 'Scene')
            const intersects = raycaster.intersectObjects(s.children, true);
            for(let j=0; j<intersects.length;j++ ) { 
                if (intersects[j].object.type == 'AxesHelper') {
                    continue;
                }
    
                // get txfm parent
                const txfm = getTXFMParent(intersects[j].object);
    
                if (txfm && Object.keys(hoverElements).indexOf(txfm.name) >= 0){
                    // recursivelySetOpacity(txfm, 0.5)
                    console.log('clicked ' , hoverElements[txfm.name])

                }
                

    
                break;
            }
        }, false);
    } );

}

function onWindowResize() {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    const cv = document.getElementById('canvas-container').children[0]
    renderer.setSize( cv.innerWidth, cv.innerHeight );

}

function getMousePos(canvas, evt) {
    var rect = canvas.getBoundingClientRect();

    mouse.x = ( ( evt.clientX - rect.left ) / ( rect.right - rect.left ) ) * 2 - 1;
    mouse.y = - ( ( evt.clientY - rect.top ) / ( rect.bottom - rect.top) ) * 2 + 1;

}

let hovered = {};

let hoverElements = {
    'TXFM_1629': 'Reset',
    'TXFM_4865': 'NMI',
}

function animate() {

    requestAnimationFrame( animate );
    const s = scene.children.find(sc => sc.type === 'Scene')


    //controls.update(); // to support damping
    if (typeof s !== 'undefined') {
        raycaster.setFromCamera(mouse, camera);
        const hoverText = document.getElementById('text-label')

        const intersects = raycaster.intersectObjects(s.children, true);
        
        if (intersects.length === 0) {
            // recursivelyUnsetOpacity(hovered)
            hovered = {}
            hoverText.innerText = ''
        }

        
    
        for(let j=0; j<intersects.length;j++ ) { 
            if (intersects[j].object.type == 'AxesHelper') {
                continue;
            }

            // get txfm parent
            const txfm = getTXFMParent(intersects[j].object);

            if (typeof hovered.name !== 'undefined' && txfm &&  hovered.name !== txfm.name) {
                // recursivelyUnsetOpacity(hovered)
                hoverText.innerText = ''
                if (Object.keys(hoverElements).indexOf(txfm.name) >= 0){
                    // recursivelySetOpacity(txfm, 0.5)

                    hoverText.innerText = hoverElements[txfm.name]
                }
                console.log(txfm.name)
            }

            hovered = txfm;
            break;
        }
    }
    renderer.render( scene, camera );
}

function recursivelySetOpacity(object, opacity) {
    if(typeof object.children === 'undefined' || object.children.length === 0) {
        return;
    }
    for(let i=0; i<object.children.length;i++ ) {
        const child = object.children[i]
        if (child.material && typeof child.userData.oldMaterial === 'undefined') {
            const newMaterial = child.material.clone();
            child.userData.oldMaterial = child.material.clone()
            
            newMaterial.transparent = true;
            newMaterial.opacity = opacity;
            child.material = newMaterial;
            // console.log('saved userData', child)
        }
        
        if (child.children) {
            recursivelySetOpacity(child, opacity)
        }
    }
}

function recursivelyUnsetOpacity(object) {
    if(typeof object.children === 'undefined' || object.children.length === 0) {
        return;
    }
    for(let i=0; i<object.children.length;i++ ) {
        const child = object.children[i]
        if(typeof child.material !== 'undefined' && typeof child.userData.oldMaterial !== 'undefined') {
            // console.log('current material', child.material)
            // console.log('saved material', child.userData.oldMaterial)
            child.material = child.userData.oldMaterial;

            delete child.userData.oldMaterial
        }
        if (child.children) {
            recursivelyUnsetOpacity(child)
        }
    }
}

function getTXFMParent(object) {
    if (object.parent && object.parent.name === 'TXFM_1') {
        return object
    }
    if (object.parent) {
        return getTXFMParent(object.parent)
    }
    return null;
}



function chooseRom(file) {

    var reader = new FileReader();
    var fileByteArray = [];
    reader.readAsArrayBuffer(file);

    reader.onloadend = function (evt) {
        if (evt.target.readyState == FileReader.DONE) {
            var arrayBuffer = evt.target.result,
                array = new Uint8Array(arrayBuffer);
            for (var i = 0; i < array.length; i++) {
                fileByteArray.push(array[i]);
            }

            loadedModule.ccall('set_rom', "void", ["array"], [fileByteArray])
        }
    }

    
}


